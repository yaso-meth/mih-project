import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_providers/ollama_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';

class MzansiAiProvider extends ChangeNotifier {
  bool ttsOn;
  int toolIndex;
  String? startUpQuestion;
  late OllamaProvider ollamaProvider;

  MzansiAiProvider({
    this.toolIndex = 0,
    this.ttsOn = false,
  }) {
    ollamaProvider = OllamaProvider(
      baseUrl: "${AppEnviroment.baseAiUrl}/api",
      model: AppEnviroment.getEnv() == "Prod"
          ? 'gemma3n:e4b'
          : "qwen3-vl:2b-instruct",
      think: false,
      systemPrompt: "You are Mzansi AI, a helpful and friendly AI assistant running on the 'MIH App'.\n" +
          "The MIH App was created by 'Mzansi Innovation Hub', a South African-based startup company." +
          "Your primary purpose is to assist users by answering general questions and helping with creative writing tasks or any other task a user might have for you.\n" +
          "Maintain a casual and friendly tone, but always remain professional.\n" +
          "Strive for a balance between being empathetic and delivering factual information accurately.\n" +
          "You may use lighthearted or playful language if the context is appropriate and enhances the user experience.\n" +
          "You operate within the knowledge domain of the 'MIH App'.\n" +
          "Here is a description of the MIH App and its features:\n" +
          "MIH App Description: MIH is the first super app of Mzansi, designed to streamline both personal and business life. It's an all-in-one platform for managing professional profiles, teams, appointments, and quick calculations. \n" +
          "Key Features:\n" +
          "- Mzansi Profile: Central hub for managing personal and business information, including business team details." +
          "- Mzansi Wallet: Digitally store loyalty cards.\n" +
          "- Patient Manager (For Medical Practices): Seamless patient appointment scheduling and data management.\n" +
          "- Mzansi AI: Your friendly AI assistant for quick answers and support (that's you!).\n" +
          "- Mzansi Directory: A place to search and find out more about the people and businesses across Mzansi.\n" +
          "- Calendar: Integrated calendar for managing personal and business appointments.\n" +
          "- Calculator: Simple calculator with tip and forex calculation functionality.\n" +
          "- MIH Minesweeper: The first game from MIH! It's the classic brain-teaser ready to entertain you no matter where you are.\n" +
          "- MIH Access: Manage and view profile access security.\n" +
          "**Core Rules and Guidelines:**\n" +
          "- **Accuracy First:** Always prioritize providing correct information.\n" +
          "- **Uncertainty Handling:** If you are unsure about an answer, politely respond with: 'Please bear with us as we are still learning and do not have all the answers.'\n" +
          "- **Response Length:** Aim to keep responses under 250 words. If a more comprehensive answer is required, exceed this limit but offer to elaborate further (e.g., 'Would you like me to elaborate on this topic?').\n" +
          "- **Language & Safety:** Never use offensive language or generate harmful content. If a user presses for information that is inappropriate or out of bounds, clearly state why you cannot provide it (e.g., 'I cannot assist with that request as it goes against my safety guidelines.').\n" +
          "- **Out-of-Scope Questions:** - If a question is unclear, ask the user to rephrase or clarify it. - If a question is entirely out of your scope and you cannot provide a useful answer, admit you don't know. - If a user is unhappy with your response or needs further assistance beyond your capabilities, suggest they visit the 'Mzansi Innovation Hub Social Media Pages' for more direct support. Do not provide specific links, just refer to the pages generally.\n" +
          "- **Target Audience:** Adapt your explanations to beginners and intermediate users, but be prepared for more complex questions from expert users. Ensure your language is clear and easy to understand.\n",
    )..addListener(() {
        notifyListeners(); // Forward OllamaProvider notifications
      });
  }

  void reset() {
    toolIndex = 0;
    startUpQuestion = null;
    notifyListeners();
  }

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setTTSstate(bool ttsOn) {
    this.ttsOn = ttsOn;
    notifyListeners();
  }

  void setStartUpQuestion(String? question) {
    startUpQuestion = question;
    notifyListeners();
  }

  void clearStartUpQuestion() {
    startUpQuestion = null;
  }

  MarkdownStyleSheet getLlmChatMarkdownStyle(BuildContext context) {
    TextStyle body = TextStyle(
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    TextStyle heading1 = TextStyle(
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      fontSize: 24,
      fontWeight: FontWeight.w400,
    );
    TextStyle heading2 = TextStyle(
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );
    TextStyle code = TextStyle(
      color: Colors.black,
      // MihColors.getBluishPurpleColor(
      //     MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    BoxDecoration codeBlock = BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      color: MihColors.getSilverColor(
          MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha(76),
          blurRadius: 8,
          offset: Offset(2, 2),
        ),
      ],
    );
    return MarkdownStyleSheet(
      a: body,
      blockquote: body,
      checkbox: body,
      del: body,
      em: body.copyWith(fontStyle: FontStyle.italic),
      h1: heading1,
      h2: heading2,
      h3: body.copyWith(fontWeight: FontWeight.bold),
      h4: body,
      h5: body,
      h6: body,
      listBullet: body,
      img: body,
      strong: body.copyWith(fontWeight: FontWeight.bold),
      p: body,
      tableBody: body,
      tableHead: body,
      code: code,
      codeblockDecoration: codeBlock,
    );
  }

  LlmChatViewStyle? getChatStyle(BuildContext context) {
    return LlmChatViewStyle(
      backgroundColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      progressIndicatorColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      disabledButtonStyle: ActionButtonStyle(
        icon: MihIcons.mzansiAi,
        iconColor: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        iconDecoration: BoxDecoration(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      recordButtonStyle: ActionButtonStyle(
        iconColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        iconDecoration: BoxDecoration(
          color: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      submitButtonStyle: ActionButtonStyle(
        icon: Icons.send,
        iconColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        iconDecoration: BoxDecoration(
          color: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      stopButtonStyle: ActionButtonStyle(
        iconColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        iconDecoration: BoxDecoration(
          color: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      actionButtonBarDecoration: BoxDecoration(
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        borderRadius: BorderRadius.circular(25),
      ),
      // Mzansi AI Chat Style
      llmMessageStyle: LlmMessageStyle(
        icon: MihIcons.mzansiAi,
        iconColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        iconDecoration: BoxDecoration(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        markdownStyle: getLlmChatMarkdownStyle(context),
      ),
      // User Chat Style
      userMessageStyle: UserMessageStyle(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          color: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        textStyle: TextStyle(
          fontSize: 16,
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      // User Input Style
      chatInputStyle: ChatInputStyle(
        backgroundColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        decoration: BoxDecoration(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        hintStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
        hintText: "Ask Mzansi AI...",
      ),
      // Suggestions Style
      suggestionStyle: SuggestionStyle(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          color: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ],
        ),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      copyButtonStyle: ActionButtonStyle(
        iconColor: MihColors.getSecondaryInvertedColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
      editButtonStyle: ActionButtonStyle(
        iconColor: MihColors.getSecondaryInvertedColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
      cancelButtonStyle: ActionButtonStyle(
        iconDecoration: BoxDecoration(
          color: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
        iconColor: MihColors.getSecondaryInvertedColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      addButtonStyle: ActionButtonStyle(
        iconDecoration: BoxDecoration(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          borderRadius: BorderRadius.circular(25),
        ),
        iconColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      menuColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
