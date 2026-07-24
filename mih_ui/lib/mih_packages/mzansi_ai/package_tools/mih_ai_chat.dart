import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
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
  Uint8List? _pendingBase64Image;
  bool _isLoading = false;
  bool _isTalking = false;

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
    _chatController.clearMessages();
    _chatController.showWelcomeMessage = true;
    aiProvider.ollamaProvider.resetChat();
  }

  void saveHistory(
      MzansiProfileProvider profileProvider, MzansiAiProvider aiProvider) {
    final history = aiProvider.ollamaProvider.history.toList();
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
    String formattedDateTimeNow = formatter.format(now);
    List<Map<String, dynamic>> messages = [];
    for (int i = 0; i < history.length; i++) {
      final map = history[i].toJson();
      map["order"] = i;
      messages.add(map);
    }

    final historyMap = <String, dynamic>{
      "conversation_id": "1234-asdf-5678-qwert",
      "app_id": profileProvider.user!.app_id,
      "modified_date": formattedDateTimeNow,
      "messages": messages, // The list of messages is included here
    };

    const encoder = JsonEncoder.withIndent(' ');
    String jsonHistory = encoder.convert(historyMap);
    debugPrint("History: $jsonHistory");
  }

  void stopTTS(MzansiAiProvider aiProvider) {
    if (!kIsWeb && Platform.isLinux) {
      Process.run('spd-say', ['-S']);
    } else {
      _tts.stop();
    }
    aiProvider.setTTSstate(false);
  }

  Future<void> initTts(MzansiAiProvider aiProvider) async {
    List<dynamic>? allVoices = await _tts.voices;
    var myVoices = allVoices
        ?.where((v) =>
            v['locale'] == 'en-US' &&
            v['gender'] == 'female' &&
            v['is_neural'] == '1')
        .toList();
    KenLogger.info("NoVoices: ${myVoices!.length}");
    if (myVoices.isNotEmpty) {
      await _tts.setVoice(Map<String, String>.from(myVoices.first));
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
    try {
      MzansiAiProvider aiProvider = context.read<MzansiAiProvider>();
      final stream = aiProvider.ollamaProvider.sendMessageStream(
        message.text,
        images: images,
      );
      StringBuffer fullResponse = StringBuffer();
      await for (final chunk in stream) {
        if (!_isTalking) {
          setState(() {
            _isTalking = true;
          });
        }
        fullResponse.write(chunk);
        _chatController.updateMessage(
          ChatMessage(
            text: fullResponse.toString(),
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
          text: fullResponse.toString(),
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
    _tts.stop();
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
                    // if (!aiProvider.ttsOn) {
                    //   speakLastMessage(aiProvider);
                    // } else {
                    //   stopTTS(aiProvider);
                    // }
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
