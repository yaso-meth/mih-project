import 'dart:async';
import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_numeric_stepper.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_radio_options.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ollama_dart/ollama_dart.dart' as ollama;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AiChat extends StatefulWidget {
  const AiChat({
    super.key,
  });

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();
  final TextEditingController _ttsVoiceController = TextEditingController();
  final ValueNotifier<bool> _showModelOptions = ValueNotifier(false);
  FlutterTts _flutterTts = FlutterTts();
  final ValueNotifier<String> _ttsVoiceName = ValueNotifier("");
  // bool _ttsOn = false;
  String? textStream;
  List<Map> _voices = [];
  List<String> _voicesString = [];
  List<types.Message> _messages = [];
  late types.User _user;
  late types.User _mihAI;
  String systemPromt = "0";
  bool _aiThinking = false;
  final client = ollama.OllamaClient(
    baseUrl: "${AppEnviroment.baseAiUrl}/api",
  );
  List<ollama.Message> _chatHistory = [];
  double _chatFrontSize = 15;

  String getModel() {
    return AppEnviroment.getEnv() == "Prod" ? 'gemma3n:e4b' : "gemma3:1b";
  }

  String setSystemPromt() {
    String temp = "";
    temp +=
        "You are Mzansi AI, a helpful and friendly AI assistant running on the 'MIH App'.\n";
    temp +=
        "The MIH App was created by 'Mzansi Innovation Hub', a South African-based startup company.";
    temp +=
        "Your primary purpose is to assist users by answering general questions and helping with creative writing tasks or any other task a user might have for you.\n";
    temp +=
        "Maintain a casual and friendly tone, but always remain professional.\n";
    temp +=
        "Strive for a balance between being empathetic and delivering factual information accurately.\n";
    temp +=
        "You may use lighthearted or playful language if the context is appropriate and enhances the user experience.\n";
    temp += "You operate within the knowledge domain of the 'MIH App'.\n";
    temp += "Here is a description of the MIH App and its features:\n";
    temp +=
        "MIH App Description: MIH is the first super app of Mzansi, designed to streamline both personal and business life. It's an all-in-one platform for managing professional profiles, teams, appointments, and quick calculations. \n";
    temp += "Key Features:\n";
    temp +=
        "- Mzansi Profile: Central hub for managing personal and business information, including business team details.";
    temp += "- Mzansi Wallet: Digitally store loyalty cards.\n";
    temp +=
        "- Patient Manager (For Medical Practices): Seamless patient appointment scheduling and data management.\n";
    temp +=
        "- Mzansi AI: Your friendly AI assistant for quick answers and support (that's you!).\n";
    temp +=
        "- Mzansi Directory: A place to search and find out more about the people and businesses across Mzansi.\n";
    temp +=
        "- Calendar: Integrated calendar for managing personal and business appointments.\n";
    temp +=
        "- Calculator: Simple calculator with tip and forex calculation functionality.\n";
    temp += "- MIH Access: Manage and view profile access security.\n";
    temp +=
        "- MIH Minesweeper: The first game from MIH! It's the classic brain-teaser ready to entertain you no matter where you are.\n";
    temp += "**Core Rules and Guidelines:**\n";
    temp +=
        "- **Accuracy First:** Always prioritize providing correct information.\n";
    temp +=
        "- **Uncertainty Handling:** If you are unsure about an answer, politely respond with: 'Please bear with us as we are still learning and do not have all the answers.'\n";
    temp +=
        "- **Response Length:** Aim to keep responses under 250 words. If a more comprehensive answer is required, exceed this limit but offer to elaborate further (e.g., 'Would you like me to elaborate on this topic?').\n";
    temp +=
        "- **Language & Safety:** Never use offensive language or generate harmful content. If a user presses for information that is inappropriate or out of bounds, clearly state why you cannot provide it (e.g., 'I cannot assist with that request as it goes against my safety guidelines.').\n";
    temp +=
        "- **Out-of-Scope Questions:** - If a question is unclear, ask the user to rephrase or clarify it. - If a question is entirely out of your scope and you cannot provide a useful answer, admit you don't know. - If a user is unhappy with your response or needs further assistance beyond your capabilities, suggest they visit the 'Mzansi Innovation Hub Social Media Pages' for more direct support. Do not provide specific links, just refer to the pages generally.\n";
    temp +=
        "- **Target Audience:** Adapt your explanations to beginners and intermediate users, but be prepared for more complex questions from expert users. Ensure your language is clear and easy to understand.\n";
    return temp;
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    FocusScope.of(context).unfocus();
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    //Add user prompt to history
    setState(() {
      _chatHistory.add(
        ollama.Message(
          role: ollama.MessageRole.user,
          content: message.text,
        ),
      );
    });

    _addMessage(textMessage);

    _handleMessageBack(message.text);
  }

  void _handleMessageBack(String userMessage) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    Stream<String> aiChatStream =
        _generateChatCompletionWithHistoryStream(userMessage, client);

    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return responseWindow(aiChatStream);
      },
    );
  }

  Widget responseWindow(
    Stream<String> aiChatStream,
  ) {
    return StreamBuilder(
      stream: aiChatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          textStream = snapshot.requireData;
          // print("Text: $textStream");
          // _speakText(textStream!);
          return MihPackageWindow(
            fullscreen: false,
            windowTitle: 'Mzansi AI Thoughts',
            menuOptions: _aiThinking == true
                ? null
                : [
                    SpeedDialChild(
                      child: Icon(
                        Icons.volume_up,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      label: "Read Aloud",
                      labelBackgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      labelStyle: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onTap: () {
                        _speakText(snapshot.requireData);
                      },
                    )
                  ],
            onWindowTapClose: () {
              _captureAIResponse(snapshot.requireData);
              _flutterTts.stop();
              Navigator.of(context).pop();
            },
            windowBody: SizedBox(
              width: double.infinity,
              // color: Colors.black,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // SelectionArea(
                  //   child: GptMarkdown(
                  //     snapshot.requireData,
                  //     textAlign: TextAlign.left,
                  //     style: TextStyle(
                  //       color: MihColors.getSecondaryColor(
                  //           MzansiInnovationHub.of(context)!.theme.mode ==
                  //               "Dark"),
                  //       fontSize: _chatFrontSize,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  SelectionArea(
                    child: Text(
                      snapshot.requireData,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: _chatFrontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return MihPackageWindow(
            fullscreen: false,
            windowTitle: 'Mzansi AI Thoughts',
            // windowTools: [],
            onWindowTapClose: () {
              Navigator.of(context).pop();
            },
            windowBody: Mihloadingcircle(),
          );
        }
      },
    );
  }

  void _captureAIResponse(String responseMessage) {
    types.TextMessage textMessage;
    setState(() {
      _chatHistory.add(
        ollama.Message(
          role: ollama.MessageRole.assistant,
          content: responseMessage,
        ),
      );
    });
    textMessage = types.TextMessage(
      author: _mihAI,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),

      text: responseMessage
          .replaceAll("<think>\n\n", "**Thinking:**\n")
          .replaceAll("<think>\n", "**Thinking:**\n")
          .replaceAll("</think>\n\n", "\n**Answer:**\n"), //message.text,
    );

    _addMessage(textMessage);
  }

  Stream<String> _generateChatCompletionWithHistoryStream(
    String userMessage,
    final ollama.OllamaClient client,
  ) async* {
    final aiStream = client.generateChatCompletionStream(
      request: ollama.GenerateChatCompletionRequest(
        model: _modelController.text,
        messages: _chatHistory,
      ),
    );
    String text = '';
    setState(() {
      _aiThinking = true;
    });
    await for (final res in aiStream) {
      text += (res.message.content);
      yield text;
    }
    setState(() {
      _aiThinking = false;
    });
  }

  void _resetChat() {
    setState(() {
      _messages = [];
      _chatHistory = [];
      _loadMessages();
    });
  }

  ChatTheme getChatTheme() {
    return DarkChatTheme(
      backgroundColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      inputBackgroundColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      inputTextColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      inputTextCursorColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      primaryColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      secondaryColor: MihColors.getGreenColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      errorColor: MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      sentMessageBodyTextStyle: TextStyle(
        color: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        fontSize: _chatFrontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      receivedMessageBodyTextStyle: TextStyle(
        color: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        fontSize: _chatFrontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      emptyChatPlaceholderTextStyle: TextStyle(
        color: MihColors.getGreyColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        fontSize: _chatFrontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
    );
  }

  Widget _getSettings() {
    return ValueListenableBuilder(
      valueListenable: _showModelOptions,
      builder: (BuildContext context, bool value, Widget? child) {
        return Visibility(
          visible: value,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 3.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          SizedBox(
                            width: 300,
                            child: MihRadioOptions(
                              controller: _modelController,
                              hintText: "AI Model",
                              fillColor: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              secondaryFillColor: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              requiredText: true,
                              radioOptions: [getModel()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 230,
                            child: MihDropdownField(
                              controller: _ttsVoiceController,
                              hintText: "AI Voice",
                              dropdownOptions: _voicesString,
                              editable: true,
                              enableSearch: true,
                              requiredText: true,
                              validator: (value) {
                                return MihValidationServices().isEmpty(value);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  25), // Optional: rounds the corners
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(60, 0, 0,
                                      0), // 0.2 opacity = 51 in alpha (255 * 0.2)
                                  spreadRadius: -2,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 2.0,
                                left: 5.0,
                              ),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: IconButton.filled(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                            MihColors.getGreenColor(
                                                MzansiInnovationHub.of(context)!
                                                        .theme
                                                        .mode ==
                                                    "Dark")),
                                  ),
                                  color: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                  iconSize: 25,
                                  onPressed: () {
                                    print("Start TTS now");
                                    _speakText(
                                        "This is the sample of the Mzansi A.I Voice.");
                                  },
                                  icon: const Icon(
                                    Icons.volume_up,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 300,
                            child: MihNumericStepper(
                              controller: _fontSizeController,
                              fillColor: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              inputColor: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              hintText: "Font Size",
                              requiredText: true,
                              minValue: 1,
                              // maxValue: 5,
                              validationOn: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void loadingPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
  }

  void _speakText(String text) async {
    try {
      loadingPopUp(context);
      await _flutterTts.stop(); // Stop any ongoing speech
      await _flutterTts.speak(text).then((value) {
        Navigator.of(context).pop();
      }); // Speak the new text
    } catch (e) {
      Navigator.of(context).pop();
      print("TTS Error: $e");
    }
  }

  void setTtsVoice(String voiceName) {
    _flutterTts.setVoice(
      {
        "name": voiceName,
        "locale": _voices
            .where((_voice) => _voice["name"].contains(voiceName))
            .first["locale"]
      },
    );
    _ttsVoiceController.text = voiceName;
  }

  void voiceSelected() {
    if (_ttsVoiceController.text.isNotEmpty) {
      _ttsVoiceName.value = _ttsVoiceController.text;
      // print(
      //     "======================================== Voice Set ========================================");
      setTtsVoice(_ttsVoiceController.text);
    } else {
      _ttsVoiceName.value = "";
    }
  }

  void fontSizeChanged() {
    setState(() {
      _chatFrontSize = double.parse(_fontSizeController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _modelController.dispose();
    _fontSizeController.dispose();
    _ttsVoiceController.dispose();
    _ttsVoiceController.removeListener(voiceSelected);
    _fontSizeController.removeListener(fontSizeChanged);
    client.endSession();
    _flutterTts.stop();
  }

  void initTTS() {
    _flutterTts.setVolume(1);
    _fontSizeController.addListener(fontSizeChanged);
    // _flutterTts.setSpeechRate(0.6);
    // _flutterTts.setPitch(1.0);
    _flutterTts.getVoices.then(
      (data) {
        try {
          _voices = List<Map>.from(data);

          setState(() {
            _voices = _voices
                .where(
                    (_voice) => _voice["name"].toLowerCase().contains("en-us"))
                .toList();
            _voicesString =
                _voices.map((_voice) => _voice["name"] as String).toList();
            _voicesString.sort();
            setTtsVoice(_voicesString.first);
          });
        } catch (e) {
          print(e);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    MzansiAiProvider mzansiAiProvider = context.read<MzansiAiProvider>();
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    _user = types.User(
      firstName: mzansiProfileProvider.user!.fname,
      id: mzansiProfileProvider
          .user!.app_id, //'82091008-a484-4a89-ae75-a22bf8d6f3ac',
    );
    _mihAI = types.User(
      firstName: "Mzansi AI",
      id: const Uuid().v4(),
    );
    _modelController.text = getModel();
    _fontSizeController.text = _chatFrontSize.ceil().toString();
    systemPromt = setSystemPromt();
    _chatHistory.add(
      ollama.Message(
        role: ollama.MessageRole.system,
        content: systemPromt,
      ),
    );
    initTTS();
    _ttsVoiceController.addListener(voiceSelected);
    if (mzansiAiProvider.startUpQuestion != null &&
        mzansiAiProvider.startUpQuestion!.isNotEmpty) {
      final partialText =
          types.PartialText(text: mzansiAiProvider.startUpQuestion!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleSendPressed(partialText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            _getSettings(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (_showModelOptions.value == true) {
                    setState(() {
                      _showModelOptions.value = false;
                    });
                  }
                },
                child: Chat(
                  messages: _messages,
                  emptyState: noMessagescDisplay(),
                  // onAttachmentPressed: _handleAttachmentPressed,
                  // onMessageTap: _handleMessageTap,
                  // onPreviewDataFetched: _handlePreviewDataFetched,
                  onSendPressed: _handleSendPressed,
                  showUserAvatars: false,
                  showUserNames: false,
                  user: _user,
                  theme: getChatTheme(),
                ),
              ),
            )
          ],
        ),
        Positioned(
          left: 15,
          top: 15,
          child: Visibility(
            visible: _showModelOptions.value == true,
            child: Container(
              // color: Colors.white,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(25), // Optional: rounds the corners
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(
                        60, 0, 0, 0), // 0.2 opacity = 51 in alpha (255 * 0.2)
                    spreadRadius: -2,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 2.0,
                  left: 5.0,
                ),
                child: SizedBox(
                  width: 40,
                  child: IconButton.filled(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark")),
                    ),
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    iconSize: 20,
                    onPressed: () {
                      if (_showModelOptions.value == true) {
                        setState(() {
                          _showModelOptions.value = false;
                        });
                      } else {
                        setState(() {
                          _showModelOptions.value = true;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ),
              ),
            ),
            // IconButton.filled(
            //   iconSize: 20,
            //   onPressed: () {
            //     if (_showModelOptions.value == true) {
            //       setState(() {
            //         _showModelOptions.value = false;
            //       });
            //     } else {
            //       setState(() {
            //         _showModelOptions.value = true;
            //       });
            //     }
            //   },
            //   icon: const Icon(
            //     Icons.settings,
            //   ),
            // ),
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
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "New Chat",
                labelBackgroundColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                labelStyle: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                onTap: () {
                  _resetChat();
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.settings,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "Settings",
                labelBackgroundColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                labelStyle: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                onTap: () {
                  if (_showModelOptions.value == true) {
                    setState(() {
                      _showModelOptions.value = false;
                    });
                  } else {
                    setState(() {
                      _showModelOptions.value = true;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? noMessagescDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(height: 50),
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
                  // WidgetSpan(
                  //   alignment: PlaceholderAlignment.middle,
                  //   child: Icon(
                  //     Icons.menu,
                  //     size: 20,
                  //     color: MzansiInnovationHub.of(context)!
                  //         .theme
                  //         .secondaryColor(),
                  //   ),
                  // ),
                  // TextSpan(text: " to add your first loyalty card."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
