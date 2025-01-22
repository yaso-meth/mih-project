import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:flutter/material.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final TextEditingController _chatMessageController = TextEditingController();
  Widget getChatBody(double height) {
    return Container(
      // height: height,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Mzansi AI Chat",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ],
          ),
          Divider(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
          const SizedBox(height: 10),
          Container(
            height: height - 300,
            color: Colors.black,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: MIHTextField(
                    controller: _chatMessageController,
                    hintText: "Ask Mzansi AI",
                    editable: true,
                    required: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  print("Sent Message");
                },
                icon: Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return getChatBody(height);
  }
}
