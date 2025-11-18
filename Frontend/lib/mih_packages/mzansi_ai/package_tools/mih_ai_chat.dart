import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';

class MihAiChat extends StatefulWidget {
  const MihAiChat({super.key});

  @override
  State<MihAiChat> createState() => _MihAiChatState();
}

class _MihAiChatState extends State<MihAiChat> {
  final FlutterTts _flutterTts = FlutterTts();

  Widget noMessagescDisplay() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.mzansiAi,
              size: 165,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            const SizedBox(height: 10),
            Text(
              "Mzansi AI is here to help",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  children: [
                    TextSpan(
                        text:
                            "Send us a message and we'll try our best to assist you"),
                  ],
                ),
              ),
            ),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  children: [
                    TextSpan(text: "Press "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    TextSpan(text: " to start a new chat or read last message"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetChat(MzansiAiProvider aiProvider) {
    aiProvider.ollamaProvider.resetChat();
  }

  void speakLastMessage(MzansiAiProvider aiProvider) {
    final history = aiProvider.ollamaProvider.history;
    if (history.isNotEmpty) {
      final historyList = history.toList();
      for (int i = historyList.length - 1; i >= 0; i--) {
        if (historyList[i].origin == MessageOrigin.llm &&
            historyList[i].text != null &&
            historyList[i].text!.isNotEmpty) {
          _flutterTts.speak(historyList[i].text!);
          return;
        }
      }
    }
  }

  void stopTTS(MzansiAiProvider aiProvider) {
    _flutterTts.stop();
    aiProvider.setTTSstate(false);
  }

  Future<void> initTts(MzansiAiProvider aiProvider) async {
    try {
      await _flutterTts.setSpeechRate(!kIsWeb ? 0.55 : 1);
      // await _flutterTts.setLanguage("en-US");

      // Safer voice selection with error handling
      _flutterTts.getVoices.then((data) {
        try {
          final voices = List<Map>.from(data);
          final englishVoices = voices.where((voice) {
            final name = voice["name"]?.toString().toLowerCase() ?? '';
            final locale = voice["locale"]?.toString().toLowerCase() ?? '';
            return name.contains("en-us") || locale.contains("en_us");
          }).toList();

          if (englishVoices.isNotEmpty) {
            // Use the first available English voice
            _flutterTts.setVoice({"name": englishVoices.first["name"]});
          }
          // If no voices found, use default
        } catch (e) {
          KenLogger.error("Error setting TTS voice: $e");
        }
      });
    } catch (e) {
      KenLogger.error("Error initializing TTS: $e");
    }

    _flutterTts.setStartHandler(() {
      if (mounted) {
        aiProvider.setTTSstate(true);
      }
    });

    _flutterTts.setCompletionHandler(() {
      if (mounted) {
        aiProvider.setTTSstate(false);
      }
    });

    _flutterTts.setErrorHandler((message) {
      if (mounted) {
        aiProvider.setTTSstate(false);
      }
    });
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

  @override
  void initState() {
    super.initState();
    MzansiAiProvider aiProvider = context.read<MzansiAiProvider>();
    initTts(aiProvider);
    initStartQuestion();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiAiProvider>(
      builder:
          (BuildContext context, MzansiAiProvider aiProvider, Widget? child) {
        bool hasHistory = aiProvider.ollamaProvider.history.isNotEmpty;
        String? lastMessage;
        if (hasHistory) {
          final histroyList = aiProvider.ollamaProvider.history.toList();
          lastMessage = histroyList[histroyList.length - 1].text;
        }

        return Stack(
          children: [
            LlmChatView(
              provider: aiProvider.ollamaProvider,
              messageSender: aiProvider.ollamaProvider.sendMessageStream,
              // welcomeMessage:
              //     "Mzansi AI is here to help. Send us a messahe and we'll try our best to assist you.",
              autofocus: false,
              enableAttachments: false,
              enableVoiceNotes: false,
              style: aiProvider.getChatStyle(context),
              suggestions: [
                "What is mih all about?",
                "What are the features of MIH?"
              ],
            ),
            if (hasHistory && lastMessage != null)
              Positioned(
                bottom: 80,
                left: 10,
                child: MihButton(
                  width: 35,
                  height: 35,
                  onPressed: () {
                    if (!aiProvider.ttsOn) {
                      speakLastMessage(aiProvider);
                    } else {
                      stopTTS(aiProvider);
                    }
                  },
                  buttonColor: !aiProvider.ttsOn
                      ? MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode == "Dark")
                      : MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                  child: Icon(
                    !aiProvider.ttsOn ? Icons.volume_up : Icons.volume_off,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
              ),
            Positioned(
              right: 10,
              bottom: 80,
              child: MihFloatingMenu(
                animatedIcon: AnimatedIcons.menu_close,
                children: [
                  SpeedDialChild(
                    child: Icon(
                      Icons.refresh,
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    label: "New Chat",
                    labelBackgroundColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    labelStyle: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    onTap: () {
                      resetChat(aiProvider);
                    },
                  ),
                ],
              ),
            ),
            if (!hasHistory) noMessagescDisplay(),
          ],
        );
      },
    );
  }
}
