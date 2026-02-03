import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:ollama_dart/ollama_dart.dart';
import 'package:cross_file/cross_file.dart';

class OllamaProvider extends LlmProvider with ChangeNotifier {
  OllamaProvider({
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    required String model,
    String? systemPrompt,
    bool? think,
  })  : _client = OllamaClient(
          baseUrl: baseUrl,
          headers: headers,
          queryParams: queryParams,
        ),
        _model = model,
        _systemPrompt = systemPrompt,
        _think = think,
        _history = [];
  final OllamaClient _client;
  final String _model;
  final List<ChatMessage> _history;
  final String? _systemPrompt;
  final bool? _think;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final messages = _mapToOllamaMessages([
      ChatMessage.user(prompt, attachments),
    ]);
    yield* _generateStream(messages);
  }

  Stream<String> speechToText(XFile audioFile) async* {
    KenLogger.success("Inside Custom speechToText funtion");
    // 1. Convert the XFile to the attachment format needed for the LLM.
    final attachments = [await FileAttachment.fromFile(audioFile)];
    KenLogger.success("added attachment for audio file");

    // 2. Define the transcription prompt, mirroring the logic from LlmChatView.
    const prompt =
        'translate the attached audio to text; provide the result of that '
        'translation as just the text of the translation itself. be careful to '
        'separate the background audio from the foreground audio and only '
        'provide the result of translating the foreground audio.';

    KenLogger.success("Created Prompt");
    // 3. Use your existing Ollama API call to process the prompt and attachment.
    // We are essentially running a new, one-off chat session for transcription.
    yield* generateStream(
      prompt,
      attachments: attachments,
    );
    KenLogger.success("done");
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    KenLogger.success("sendMessageStream called with: $prompt");
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);
    notifyListeners();
    KenLogger.success("History after adding messages: ${_history.length}");
    final messages = _mapToOllamaMessages(_history);
    final stream = _generateStream(messages);
    yield* stream.map((chunk) {
      llmMessage.append(chunk);
      notifyListeners();
      return chunk;
    });
    KenLogger.success("Stream completed for: $prompt");
    notifyListeners();
  }

  @override
  Iterable<ChatMessage> get history => _history;

  void resetChat() {
    _history.clear();
    notifyListeners();
  }

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }

  Stream<String> _generateStream(List<Message> messages) async* {
    final allMessages = <Message>[];
    if (_systemPrompt != null && _systemPrompt.isNotEmpty) {
      KenLogger.success("Adding system prompt to the conversation");
      allMessages.add(Message(
        role: MessageRole.system,
        content: _systemPrompt,
      ));
    }
    allMessages.addAll(messages);

    final stream = _client.generateChatCompletionStream(
      request: GenerateChatCompletionRequest(
        model: _model,
        messages: allMessages,
        think: _think,
      ),
    );
    // final stream = _client.generateChatCompletionStream(
    //   request: GenerateChatCompletionRequest(
    //     model: _model,
    //     messages: messages,
    //   ),
    // );

    yield* stream.map((res) => res.message.content);
  }

  List<Message> _mapToOllamaMessages(List<ChatMessage> messages) {
    return messages.map((message) {
      switch (message.origin) {
        case MessageOrigin.user:
          if (message.attachments.isEmpty) {
            return Message(
              role: MessageRole.user,
              content: message.text ?? '',
            );
          }
          final imageAttachments = <String>[];
          final docAttachments = <String>[];
          if (message.text != null && message.text!.isNotEmpty) {
            docAttachments.add(message.text!);
          }
          for (final attachment in message.attachments) {
            if (attachment is FileAttachment) {
              final mimeType = attachment.mimeType.toLowerCase();
              if (mimeType.startsWith('image/')) {
                imageAttachments.add(base64Encode(attachment.bytes));
              } else if (mimeType == 'application/pdf' ||
                  mimeType.startsWith('text/')) {
                throw LlmFailureException(
                  "\n\nAww, that file is a little too advanced for us right now ($mimeType)! We're still learning, but we'll get there! Please try sending us a different file type.\n\nHint: We can handle images quite well!",
                );
              }
            } else {
              throw LlmFailureException(
                'Unsupported attachment type: $attachment',
              );
            }
          }
          return Message(
            role: MessageRole.user,
            content: docAttachments.join(' '),
            images: imageAttachments,
          );

        case MessageOrigin.llm:
          return Message(
            role: MessageRole.assistant,
            content: message.text ?? '',
          );
      }
    }).toList(growable: false);
  }

  @override
  void dispose() {
    _client.endSession();
    super.dispose();
  }
}
