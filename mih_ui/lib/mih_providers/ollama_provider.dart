import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:ollama_dart/ollama_dart.dart' as ollama;
import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;

class OllamaProvider with ChangeNotifier {
  OllamaProvider({
    required String baseUrl,
    required String model,
    String? systemPrompt,
    bool? think,
  })  : _baseUrl = baseUrl,
        _httpClient = http.Client(),
        _client = ollama.OllamaClient(
          config: ollama.OllamaConfig(
            baseUrl: baseUrl,
          ),
        ),
        _model = model,
        _systemPrompt = systemPrompt,
        _think = think,
        _history = [];
  final String _baseUrl;
  final http.Client _httpClient;
  final ollama.OllamaClient _client;
  final String _model;
  final List<ollama.ChatMessage> _history;
  final String? _systemPrompt;
  final bool? _think;

  Completer<void>? _abortCompleter;
  bool get isGenerating => _abortCompleter != null;

  Stream<String> generateStream(String prompt) async* {
    final messages = [
      ollama.ChatMessage.user(prompt),
    ];
    yield* _generateStream(messages);
  }

  Stream<String> speechToText(XFile audioFile) async* {
    KenLogger.success("Inside Custom speechToText function");
    final bytes = await audioFile.readAsBytes();
    final base64Audio = base64Encode(bytes);
    const prompt =
        'translate the attached audio to text; provide the result of that '
        'translation as just the text of the translation itself.';

    final messages = [
      ollama.ChatMessage.user(prompt, images: [base64Audio]),
    ];
    yield* _generateStream(messages);
    KenLogger.success("done");
  }

  Stream<String> sendMessageStream(String prompt,
      {List<String>? images}) async* {
    final userMessage = ollama.ChatMessage.user(prompt, images: images);
    _history.add(userMessage);
    notifyListeners();
    final stream = _generateStream(List.from(_history));
    final responseBuffer = StringBuffer();
    await for (final chunk in stream) {
      responseBuffer.write(chunk);
      yield chunk;
    }

    _history.add(ollama.ChatMessage.assistant(responseBuffer.toString()));
    notifyListeners();
  }

  Iterable<ollama.ChatMessage> get history => _history;

  void resetChat() {
    _history.clear();
    notifyListeners();
  }

  set history(Iterable<ollama.ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }

  void stopGenerating() {
    if (_abortCompleter != null && !_abortCompleter!.isCompleted) {
      KenLogger.info("Aborting in-flight generation");
      _abortCompleter!.complete();
    }
  }

  Stream<String> _generateStream(List<ollama.ChatMessage> messages) async* {
    final allMessages = <ollama.ChatMessage>[];
    if (_systemPrompt != null && _systemPrompt.isNotEmpty) {
      allMessages.add(ollama.ChatMessage.system(_systemPrompt));
    }
    allMessages.addAll(messages);

    final chatRequest = ollama.ChatRequest(
      model: _model,
      messages: allMessages,
      think: ollama.ThinkValue.enabled(_think ?? false),
      stream: true,
    );

    final abortCompleter = Completer<void>();
    _abortCompleter = abortCompleter;

    final request = http.AbortableRequest(
      'POST',
      Uri.parse('$_baseUrl/api/chat'),
      abortTrigger: abortCompleter.future,
    )
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode(chatRequest.toJson());

    http.StreamedResponse response;
    try {
      response = await _httpClient.send(request);
    } on http.ClientException catch (e) {
      if (_abortCompleter != null && _abortCompleter!.isCompleted) {
        KenLogger.info("Generation aborted before response: $e");
        _abortCompleter = null;
        return;
      }

      // Otherwise, it's a real network/server error — rethrow it!
      KenLogger.error("Network connection error: $e");
      _abortCompleter = null;
      rethrow;
    } catch (e) {
      _abortCompleter = null;
      rethrow;
    }

    try {
      await for (final line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (line.trim().isEmpty) continue;

        final Object? decoded;
        try {
          decoded = jsonDecode(line);
        } on FormatException catch (e) {
          KenLogger.error("Failed to decode NDJSON line: $line ($e)");
          continue;
        }

        if (decoded is! Map<String, dynamic>) {
          KenLogger.error("Unexpected NDJSON line (not an object): $line");
          continue;
        }

        if (decoded['error'] != null) {
          throw Exception('Ollama returned an error: ${decoded['error']}');
        }

        final event = ollama.ChatStreamEvent.fromJson(decoded);
        yield event.message?.content ?? '';
      }
    } on http.ClientException catch (e) {
      // Hard-stop path: abortTrigger completed mid-stream, package:http
      // injected RequestAbortedException and closed the connection.
      KenLogger.info("Generation stopped mid-stream: $e");
    } finally {
      _abortCompleter = null;
    }
  }

  @override
  void dispose() {
    stopGenerating();
    _httpClient.close();
    _client.close();
    super.dispose();
  }
}
