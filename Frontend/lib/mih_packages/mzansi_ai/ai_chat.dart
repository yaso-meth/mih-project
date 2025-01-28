import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
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
  TextEditingController _modelCopntroller = TextEditingController();
  List<types.Message> _messages = [];
  late types.User _user;
  late types.User _mihAI;
  String systemPromt =
      "You are a helpful and friendly AI assistant. You are running on a system called MIH which was created by \"Mzansi Innovation Hub\" a South African based company.";
  final client = ollama.OllamaClient(
    baseUrl: "${AppEnviroment.baseAiUrl}/api",
  );
  List<ollama.Message> _chatHistory = [];

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
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
    types.TextMessage textMessage;
    String aiResponse = "";
    await _generateChatCompletionWithHistory(userMessage, client)
        .then((response) {
      aiResponse = response.split("</think>").last.trim();
    });
    setState(() {
      _chatHistory.add(
        ollama.Message(
          role: ollama.MessageRole.assistant,
          content: aiResponse,
        ),
      );
    });
    textMessage = types.TextMessage(
        author: _mihAI,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: aiResponse //message.text,
        );

    _addMessage(textMessage);
    print(_chatHistory.toString());
    Navigator.of(context).pop();
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

  Future<String> _generateChatCompletionWithHistory(
    String userMessage,
    final ollama.OllamaClient client,
  ) async {
    final generated = await client.generateChatCompletion(
      request: ollama.GenerateChatCompletionRequest(
        model: _modelCopntroller.text,
        messages: _chatHistory,
      ),
    );
    return generated.message.content;
  }

  void _resetChat() {
    setState(() {
      _messages = [];
      _chatHistory = [];

      _loadMessages();
    });
    // Navigator.of(context).popAndPushNamed(
    //   '/mzansi-ai',
    //   arguments: widget.signedInUser,
    // );
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
        fontSize: 17,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      receivedMessageBodyTextStyle: TextStyle(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        fontSize: 17,
        fontWeight: FontWeight.w500,
        fontFamily: 'Segoe UI',
      ),
      emptyChatPlaceholderTextStyle: TextStyle(
        color: MzanziInnovationHub.of(context)!.theme.messageTextColor(),
        fontSize: 17,
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
    _modelCopntroller.text = 'deepseek-r1:1.5b';
    // _chatHistory.add(
    //   ollama.Message(
    //     role: ollama.MessageRole.system,
    //     content: systemPromt,
    //   ),
    // );
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: false,
      bodyItem: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Chat with AI",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              IconButton(
                onPressed: () {
                  _resetChat();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: 300,
                  child: MIHDropdownField(
                    controller: _modelCopntroller,
                    hintText: "AI Model",
                    dropdownOptions: const ['deepseek-r1:1.5b'],
                    required: true,
                    editable: true,
                  ),
                ),
              )
            ],
          ),
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
