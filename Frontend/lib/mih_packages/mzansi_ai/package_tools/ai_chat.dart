import 'dart:async';
import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:ollama_dart/ollama_dart.dart' as ollama;
import 'package:uuid/uuid.dart';

class AiChat extends StatefulWidget {
  final AppUser signedInUser;
  const AiChat({
    super.key,
    required this.signedInUser,
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
        "- Calendar: Integrated calendar for managing personal and business appointments.\n";
    temp +=
        "- Calculator: Simple calculator with tip calculation functionality.\n";
    temp += "- MIH Access: Manage and view profile access security.\n";
    temp += "**Core Rules and Guidelines:**\n";
    temp +=
        "- **Accuracy First:** Always prioritize providing correct information.\n";
    temp +=
        "- **Uncertainty Handling:** If you are unsure about an answer, politely respond with: 'Please bear with us as we are still learning and do not have all the answers.'\n";
    temp +=
        "- **Response Length:** Aim to keep responses under 100 words. If a more comprehensive answer is required, exceed this limit but offer to elaborate further (e.g., 'Would you like me to elaborate on this topic?').\n";
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
          return MihAppWindow(
            fullscreen: false,
            windowTitle: 'Mzansi AI Thoughts',
            windowTools: Row(
              children: [
                Visibility(
                  visible: _aiThinking == false,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      //color: MzanziInnovationHub.of(context)!.theme.successColor(),
                      decoration: BoxDecoration(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .successColor(),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: IconButton(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onPressed: () async {
                          print("Start TTS now");

                          _speakText(snapshot.requireData);
                        },
                        icon: const Icon(Icons.volume_up),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _aiThinking == true,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      // color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                      decoration: BoxDecoration(
                        color:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: IconButton(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onPressed: () {
                          //print("Start TTS now");
                          _flutterTts.stop();
                        },
                        icon: const Icon(Icons.volume_off),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                  Stack(
                    children: [
                      Text(
                        snapshot.requireData,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          fontSize: _chatFrontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Visibility(
                          visible: _aiThinking == false,
                          child: IconButton.filled(
                            iconSize: 25,
                            autofocus: true,
                            onPressed: () {
                              _captureAIResponse(snapshot.requireData);
                              _flutterTts.stop();
                              Navigator.of(context).pop();
                            },
                            focusColor: MzanziInnovationHub.of(context)!
                                .theme
                                .successColor(),
                            icon: Icon(
                              Icons.check,
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
                            ),
                          ),

                          // MIHButton(
                          //   onTap: () {
                          //     _captureAIResponse(snapshot.requireData);
                          //     Navigator.of(context).pop();
                          //   },
                          //   buttonText: "Continue",
                          //   buttonColor: MzanziInnovationHub.of(context)!
                          //       .theme
                          //       .successColor(),
                          //   textColor: MzanziInnovationHub.of(context)!
                          //       .theme
                          //       .primaryColor(),
                          // ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return MihAppWindow(
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
      backgroundColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      inputBackgroundColor:
          MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      inputTextColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      inputTextCursorColor:
          MzanziInnovationHub.of(context)!.theme.primaryColor(),
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.successColor(),
      errorColor: MzanziInnovationHub.of(context)!.theme.errorColor(),
      sentMessageBodyTextStyle: TextStyle(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        fontSize: _chatFrontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      receivedMessageBodyTextStyle: TextStyle(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        fontSize: _chatFrontSize,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      emptyChatPlaceholderTextStyle: TextStyle(
        color: MzanziInnovationHub.of(context)!.theme.messageTextColor(),
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
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
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
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 300,
                            child: MIHDropdownField(
                              controller: _modelController,
                              hintText: "AI Model",
                              dropdownOptions: const [
                                'gemma3:4b',
                              ],
                              required: true,
                              editable: true,
                              enableSearch: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 230,
                            child: MIHDropdownField(
                              controller: _ttsVoiceController,
                              hintText: "AI Voice",
                              dropdownOptions: _voicesString,
                              required: true,
                              editable: true,
                              enableSearch: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              //color: MzanziInnovationHub.of(context)!.theme.successColor(),
                              decoration: BoxDecoration(
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .successColor(),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: IconButton(
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .primaryColor(),
                                onPressed: () {
                                  print("Start TTS now");

                                  _speakText(
                                      "This is the sample of the Mzansi A.I Voice.");
                                },
                                icon: const Icon(Icons.volume_up),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                _chatFrontSize -= 1;
                                _fontSizeController.text =
                                    _chatFrontSize.ceil().toString();
                              });
                            },
                            icon: const Icon(
                              Icons.remove,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 200,
                            child: MIHTextField(
                              controller: _fontSizeController,
                              hintText: "Chat Font Size",
                              editable: false,
                              required: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                _chatFrontSize += 1;
                                _fontSizeController.text =
                                    _chatFrontSize.ceil().toString();
                              });
                            },
                            icon: const Icon(
                              Icons.add,
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _modelController.dispose();
    _fontSizeController.dispose();
    _ttsVoiceController.dispose();
    _ttsVoiceController.removeListener(voiceSelected);
    client.endSession();
    _flutterTts.stop();
  }

  void initTTS() {
    _flutterTts.setVolume(0.7);
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
            // print(
            //     "=================== Voices ===================\n$_voicesString");

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
    _user = types.User(
      firstName: widget.signedInUser.fname,
      id: widget.signedInUser.app_id, //'82091008-a484-4a89-ae75-a22bf8d6f3ac',
    );
    _mihAI = types.User(
      firstName: "Mzansi AI",
      id: const Uuid().v4(),
    );
    _modelController.text = 'gemma3:4b';
    _fontSizeController.text = _chatFrontSize.ceil().toString();
    systemPromt = setSystemPromt();
    _chatHistory.add(
      ollama.Message(
        role: ollama.MessageRole.system,
        content: systemPromt,
      ),
    );
    _loadMessages();
    initTTS();
    _ttsVoiceController.addListener(voiceSelected);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Visibility(
                //   visible: _showModelOptions.value == true,
                //   child: IconButton.filled(
                //     iconSize: 20,
                //     onPressed: () {
                //       if (_showModelOptions.value == true) {
                //         setState(() {
                //           _showModelOptions.value = false;
                //         });
                //       } else {
                //         setState(() {
                //           _showModelOptions.value = true;
                //         });
                //       }
                //     },
                //     icon: const Icon(
                //       Icons.settings,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Text(
                    "Mzansi AI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     alignment: Alignment.centerRight,
                //     child: IconButton(
                //       onPressed: () {
                //         _resetChat();
                //       },
                //       icon: const Icon(Icons.refresh),
                //     ),
                //   ),
                // ),
              ],
            ),
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
          left: 0,
          top: 0,
          child: Visibility(
            visible: _showModelOptions.value == true,
            child: IconButton.filled(
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
                Icons.settings,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 70,
          child: MihFloatingMenu(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.refresh,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "New Chat",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  _resetChat();
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.settings,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "Settings",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
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
}
