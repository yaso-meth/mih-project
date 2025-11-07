import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:ollama_dart/ollama_dart.dart';

class OllamaProvider extends LlmProvider with ChangeNotifier {
  OllamaProvider({
    String? baseUrl,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    required String model,
    String? systemPrompt,
  })  : _client = OllamaClient(
          baseUrl: baseUrl,
          headers: headers,
          queryParams: queryParams,
        ),
        _model = model,
        _systemPrompt = systemPrompt,
        _history = [];
  final OllamaClient _client;
  final String _model;
  final List<ChatMessage> _history;
  final String? _systemPrompt;

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

          return Message(
            role: MessageRole.user,
            content: message.text ?? '',
            images: [
              for (final attachment in message.attachments)
                if (attachment is ImageFileAttachment)
                  base64Encode(attachment.bytes)
                else
                  throw LlmFailureException(
                    'Unsupported attachment type: $attachment',
                  ),
            ],
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
