import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_helpers/mih_tts_stub.dart'
    if (dart.library.js_interop) 'package:mzansi_innovation_hub/mih_helpers/mih_tts_web.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:ollama_dart/ollama_dart.dart' as ollama;
import 'package:provider/provider.dart';
import 'package:text_to_speech_plus/text_to_speech_plus.dart';

class MihAiChat extends StatefulWidget {
  const MihAiChat({super.key});

  @override
  State<MihAiChat> createState() => _MihAiChatState();
}

class _MihAiChatState extends State<MihAiChat> with WidgetsBindingObserver {
  late final ChatMessagesController _chatController;
  late final ChatUser _currentUser;
  late final ChatUser _aiUser;
  final TextToSpeechPlus _tts = TextToSpeechPlus();
  final StringBuffer _fullResponse = StringBuffer();
  bool _isFirstTtsChunk = true;
  Uint8List? _pendingBase64Image;
  bool _isLoading = false;
  bool _isTalking = false;

  String stripMarkdownRegex(String text) {
    if (text.isEmpty) return text;
    String cleaned = text;
    cleaned = cleaned.replaceAll(
      RegExp(r'<(think|thought)>[\s\S]*?<\/\1>', caseSensitive: false),
      '',
    );
    cleaned = cleaned.trim();
    if ((cleaned.startsWith('```markdown') ||
            cleaned.startsWith('```md') ||
            cleaned.startsWith('```')) &&
        cleaned.endsWith('```')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '');
      cleaned = cleaned.substring(0, cleaned.length - 3).trim();
    }
    cleaned = cleaned.replaceAll(RegExp(r'```[a-zA-Z]*\n?'), '');
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'!\[(.*?)\]\(.*?\)'),
      (match) => match[1] ?? '',
    );
    cleaned = cleaned.replaceAllMapped(
      RegExp(r'\[(.*?)\]\(.*?\)'),
      (match) => match[1] ?? '',
    );
    cleaned = cleaned.replaceAll(RegExp(r'^\s*#+\s+', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'^\s*>\s?', multiLine: true), '');
    cleaned = cleaned.replaceAll(
        RegExp(r'^\s*([*+-]|\d+\.)\s+', multiLine: true), '');
    cleaned =
        cleaned.replaceAll(RegExp(r'^\s*([-*_]){3,}\s*$', multiLine: true), '');
    cleaned = cleaned.replaceAll(RegExp(r'(\*\*|__|~~|`|\*|_)'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\$\$?'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return cleaned.trim();
  }

  void initialiseControllers(MzansiProfileProvider profileProvider) {
    _chatController = ChatMessagesController();
    _currentUser = ChatUser(
      id: profileProvider.user!.app_id,
      firstName: profileProvider.user!.username,
    );
    _aiUser = ChatUser(
      id: 'mzansi_ai',
      firstName: 'Mzansi AI',
    );
  }

  void _loadExistingHistory(MzansiAiProvider aiProvider) {
    final history = aiProvider.ollamaProvider.history;
    for (final msg in history) {
      KenLogger.info(msg.content);
      final isUser = msg.role == ollama.MessageRole.user;
      final chatMessage = ChatMessage(
        text: msg.content,
        createdAt: DateTime.now(),
        user: isUser ? _currentUser : _aiUser,
      );
      _chatController.addMessage(chatMessage);
    }
  }

  void resetChat(MzansiAiProvider aiProvider) {
    stopTTS(aiProvider);
    _chatController.clearMessages();
    _chatController.showWelcomeMessage = true;
    aiProvider.ollamaProvider.resetChat();
  }

  Future<void> _speakText(String text, {bool enqueue = false}) async {
    if (text.trim().isEmpty) return;
    if (kIsWasm) {
      try {
        speakOnWeb(stripMarkdownRegex(text), enqueue: enqueue);
      } catch (error) {
        KenLogger.error("WASM TTS Error: $error");
      }
    } else if (!kIsWeb && Platform.isLinux) {
      final args = [
        '-o',
        'espeak-ng',
        '-y',
        'en+f3',
        '-r',
        '0',
        '-p',
        '12',
        if (enqueue) '-e',
        stripMarkdownRegex(text),
      ];
      try {
        await Process.run('spd-say', args).timeout(
          const Duration(seconds: 2),
          onTimeout: () => ProcessResult(-1, -1, '', 'spd-say timed out'),
        );
      } catch (e) {
        KenLogger.error("Linux TTS error: $e");
      }
    } else {
      await _tts.speak(text, enqueue: enqueue);
    }
  }

  void stopTTS(MzansiAiProvider aiProvider) async {
    if (kIsWasm) {
      stopOnWeb();
    } else if (!kIsWeb && Platform.isLinux) {
      try {
        await Process.run('spd-say', ['-C']).timeout(
          const Duration(seconds: 1),
          onTimeout: () => ProcessResult(-1, -1, '', 'spd-say timed out'),
        );
      } catch (e) {
        KenLogger.error("Failed to stop Linux TTS: $e");
      }
    } else {
      _tts.stop();
    }
    aiProvider.setTTSstate(false);
  }

  void toggleTTS(MzansiAiProvider aiProvider) {
    unlockWebAudio();
    if (aiProvider.ttsOn) {
      stopTTS(aiProvider);
    } else {
      aiProvider.setTTSstate(true);
      _isFirstTtsChunk = false;
      if (_isLoading && _fullResponse.isNotEmpty) {
        _speakText(_fullResponse.toString(), enqueue: false);
      } else {
        final history = aiProvider.ollamaProvider.history;
        if (history.isNotEmpty) {
          final aiMessages =
              history.where((msg) => msg.role != ollama.MessageRole.user);
          if (aiMessages.isNotEmpty) {
            final lastAiMessage = aiMessages.last;
            if (lastAiMessage.content.isNotEmpty) {
              _speakText(lastAiMessage.content, enqueue: false);
            }
          }
        }
      }
    }
  }

  Future<void> initTts(MzansiAiProvider aiProvider) async {
    if (!kIsWeb && Platform.isLinux) {
      return;
    } else {
      List<dynamic>? allVoices = await _tts.voices;
      KenLogger.info("Voices: ${allVoices!.length}");
      var myVoices = allVoices
          .where((v) =>
              v['locale'] == 'en-US' &&
              v['gender'] == 'female' &&
              v['is_neural'] == '1')
          .toList();
      KenLogger.info("My Voices: ${myVoices.length}");
      if (myVoices.isNotEmpty) {
        await _tts.setVoice(Map<String, String>.from(myVoices.first));
      }
    }
  }

  void initStartQuestion() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final mzansiAiProvider = context.read<MzansiAiProvider>();
      final startQuestion = mzansiAiProvider.startUpQuestion;
      if (startQuestion != null && startQuestion.isNotEmpty) {
        final stream =
            mzansiAiProvider.ollamaProvider.sendMessageStream(startQuestion);
        stream.listen((chunk) {});
        mzansiAiProvider.clearStartUpQuestion();
      }
    });
  }

  Future<void> _handleSendMessage(ChatMessage message) async {
    setState(() => _isLoading = true);
    _chatController.addMessage(message);

    final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();
    final aiMessage = ChatMessage(
      text: '',
      createdAt: DateTime.now(),
      user: _aiUser,
      isMarkdown: true,
      customProperties: {
        'id': aiMessageId,
        'isStreaming': true,
      },
    );

    _chatController.addStreamingMessage(aiMessage);
    final List<String>? images = _pendingBase64Image != null
        ? [base64Encode(_pendingBase64Image!)]
        : null;
    setState(() {
      _pendingBase64Image = null;
    });
    _fullResponse.clear();
    _isFirstTtsChunk = true;
    try {
      MzansiAiProvider aiProvider = context.read<MzansiAiProvider>();
      final stream = aiProvider.ollamaProvider.sendMessageStream(
        message.text,
        images: images,
      );
      await for (final chunk in stream) {
        if (!_isTalking) {
          setState(() {
            _isTalking = true;
          });
        }
        _fullResponse.write(chunk);
        if (aiProvider.ttsOn && chunk.isNotEmpty) {
          if (_isFirstTtsChunk) {
            _speakText(chunk, enqueue: false);
            _isFirstTtsChunk = false;
          } else {
            _speakText(chunk, enqueue: true);
          }
        }
        _chatController.updateMessage(
          ChatMessage(
            text: _fullResponse.toString(),
            createdAt: DateTime.now(),
            user: _aiUser,
            isMarkdown: true,
            customProperties: {
              'id': aiMessageId,
              'isStreaming': true,
            },
          ),
        );
      }
      _chatController.updateMessage(
        ChatMessage(
          text: _fullResponse.toString(),
          createdAt: DateTime.now(),
          user: _aiUser,
          isMarkdown: true,
          customProperties: {
            'id': aiMessageId,
            'isStreaming': false,
          },
        ),
      );
      _chatController.stopStreamingMessage(aiMessageId);
    } catch (e) {
      KenLogger.error("Error generating stream: $e");
      _chatController.updateMessage(
        ChatMessage(
          text:
              "Please bear with us as we are still learning and do not have all the answers.",
          createdAt: DateTime.now(),
          user: _aiUser,
          isMarkdown: true,
          customProperties: {
            'id': aiMessageId,
            'isStreaming': false,
          },
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isTalking = false;
      });
    }
  }

  void _stopGenerating() {
    final aiProvider = context.read<MzansiAiProvider>();
    aiProvider.ollamaProvider.stopGenerating();
  }

  Widget imagePreview() {
    if (_pendingBase64Image == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              MihImageDisplay(
                imageFile: MemoryImage(_pendingBase64Image!),
                height: 100,
                expandable: true,
                editable: false,
                blur: true,
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () => setState(() => _pendingBase64Image = null),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: MihColors.secondary(),
                    child: const Icon(Icons.close, size: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget fileUploadButton() {
    return IconButton(
      icon: Icon(
        Icons.attach_file_rounded,
        color: MihColors.secondary(),
      ),
      tooltip: 'Attach Image',
      onPressed: () async {
        final platformFile = await MihFileApi.pickImage();
        if (platformFile != null) {
          final bytes = await platformFile.readAsBytes();
          setState(() {
            _pendingBase64Image = bytes;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    MzansiAiProvider aiProvider = context.read<MzansiAiProvider>();
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    initialiseControllers(profileProvider);
    _loadExistingHistory(aiProvider);
    initTts(aiProvider);
    initStartQuestion();
  }

  @override
  void dispose() {
    MzansiAiProvider aiProvider = context.read<MzansiAiProvider>();
    stopTTS(aiProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, MzansiAiProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        MzansiAiProvider aiProvider,
        Widget? child,
      ) {
        double width = MediaQuery.sizeOf(context).width;
        final history = aiProvider.ollamaProvider.history;
        return Stack(
          children: [
            AiChatWidget(
              currentUser: _currentUser,
              aiUser: _aiUser,
              controller: _chatController,
              onSendMessage: _handleSendMessage,
              onCancelGenerating: _stopGenerating,
              loadingConfig: aiProvider.getLoadingConfig(
                _isLoading,
                _isTalking,
              ),
              exampleQuestions: [
                ExampleQuestion(
                  question: "What is MIH all about?",
                  config: aiProvider.getExampleQuestionCOnfig(),
                ),
                ExampleQuestion(
                  question: "What are the features of MIH?",
                  config: aiProvider.getExampleQuestionCOnfig(),
                ),
              ],
              welcomeMessageConfig: aiProvider.getWelcomeMessageConfig(
                profileProvider.user!.fname,
                width,
                context,
              ),
              inputOptions: aiProvider.getInputOptions(
                attachmentPreviewBuilder: (context) {
                  return imagePreview();
                },
              ),
              messageOptions: aiProvider.getMessageOptions(context),
              scrollToBottomOptions: aiProvider.getScrollToBottomOptions(),
              fileUploadOptions: FileUploadOptions(
                enabled: true,
                maxFilesPerMessage: 1,
                customUploadButtonBuilder: (context, defaultOnPressed) {
                  return fileUploadButton();
                },
              ),
            ),
            if (history.isNotEmpty)
              Positioned(
                bottom: 80,
                left: 10,
                child: MihButton(
                  width: 35,
                  height: 35,
                  onPressed: () {
                    toggleTTS(aiProvider);
                  },
                  buttonColor:
                      !aiProvider.ttsOn ? MihColors.green() : MihColors.red(),
                  child: Icon(
                    !aiProvider.ttsOn ? Icons.volume_up : Icons.volume_off,
                    color: MihColors.primary(),
                  ),
                ),
              ),
            if (history.isNotEmpty)
              Positioned(
                right: 10,
                bottom: 80,
                child: MihFloatingMenu(
                  animatedIcon: AnimatedIcons.menu_close,
                  children: [
                    SpeedDialChild(
                      child: Icon(
                        Icons.refresh,
                        color: MihColors.primary(),
                      ),
                      label: "New Chat",
                      labelBackgroundColor: MihColors.green(),
                      labelStyle: TextStyle(
                        color: MihColors.primary(),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.green(),
                      onTap: () {
                        resetChat(aiProvider);
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
