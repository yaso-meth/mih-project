import 'dart:async';
import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/services.dart' show rootBundle;
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
  final TextEditingController _modelCopntroller = TextEditingController();
  final TextEditingController _fontSizeCopntroller = TextEditingController();
  final ValueNotifier<bool> _showModelOptions = ValueNotifier(false);
  List<types.Message> _messages = [];
  late types.User _user;
  late types.User _mihAI;
  String systemPromt =
      "You are a helpful and friendly AI assistant. You are running on a system called 'MIH' which was created by 'Mzansi Innovation Hub' a South African based company. The name we have given you is 'Mzansi Ai'. Please keep your thinking to a few paragraphs and your answer to one short paragraph.";
  bool _aiThinking = false;
  final client = ollama.OllamaClient(
    baseUrl: "${AppEnviroment.baseAiUrl}/api",
  );
  List<ollama.Message> _chatHistory = [];
  double _chatFrontSize = 17;

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
          return MihAppWindow(
            fullscreen: false,
            windowTitle: 'Mzansi AI Thoughts',
            windowTools: const [],
            onWindowTapClose: () {
              _captureAIResponse(snapshot.requireData);
              Navigator.of(context).pop();
            },
            windowBody: [
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
          );
        } else {
          return MihAppWindow(
            fullscreen: false,
            windowTitle: 'Mzansi AI Thoughts',
            windowTools: [],
            onWindowTapClose: () {
              Navigator.of(context).pop();
            },
            windowBody: const [
              Mihloadingcircle(),
            ],
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
        model: _modelCopntroller.text,
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _modelCopntroller.dispose();
    client.endSession();
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
    _modelCopntroller.text = 'gemma2:2b';
    _fontSizeCopntroller.text = _chatFrontSize.ceil().toString();
    _chatHistory.add(
      ollama.Message(
        role: ollama.MessageRole.system,
        content: systemPromt,
      ),
    );
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: false,
      bodyItem: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Visibility(
                        visible: _showModelOptions.value == false,
                        child: IconButton(
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
                          icon: const Icon(Icons.settings),
                        ),
                      ),
                      Visibility(
                        visible: _showModelOptions.value == true,
                        child: IconButton.filled(
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
                          icon: const Icon(Icons.settings),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                "Mzansi AI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      _resetChat();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: _showModelOptions,
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: SizedBox(
                          width: 300,
                          child: MIHDropdownField(
                            controller: _modelCopntroller,
                            hintText: "AI Model",
                            dropdownOptions: const [
                              'deepseek-r1:1.5b',
                              'gemma2:2b'
                            ],
                            required: true,
                            editable: true,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          ValueListenableBuilder(
            valueListenable: _showModelOptions,
            builder: (BuildContext context, bool value, Widget? child) {
              return Visibility(
                visible: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton.filled(
                        onPressed: () {
                          setState(() {
                            _chatFrontSize -= 1;
                            _fontSizeCopntroller.text =
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
                          controller: _fontSizeCopntroller,
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
                            _fontSizeCopntroller.text =
                                _chatFrontSize.ceil().toString();
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 5),
          Expanded(
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
          )
        ],
      ),
    );
  }
}
