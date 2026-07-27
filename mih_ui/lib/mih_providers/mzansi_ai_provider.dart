import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/ollama_provider.dart';
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
      baseUrl: AppEnviroment.baseAiUrl,
      model:
          AppEnviroment.getEnv() == "Prod" ? "mzansiai:latest" : "qwen3.5:0.8b",
      think: false,
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

  InputOptions? getInputOptions({
    Widget Function(BuildContext)? attachmentPreviewBuilder,
  }) {
    return InputOptions(
      sendButtonIcon: Icons.send_rounded,
      sendOnEnter: true,
      stopButtonColor: MihColors.red(),
      attachmentPreviewBuilder: attachmentPreviewBuilder,
      textStyle: TextStyle(
        color: MihColors.primary(),
        fontWeight: FontWeight.w500,
      ),
      cursorColor: MihColors.primary(),
      decoration: InputDecoration(
        hintText: 'Ask Mzansi Ai...',
        hintStyle: TextStyle(
          color: MihColors.primary(),
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: MihColors.secondary(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: MihColors.secondary()),
        ),
      ),
    );
  }

  MessageOptions getMessageOptions(BuildContext context) {
    return MessageOptions(
      markdownStyleSheet: getMarkdownStyleSheet(),
      markdownBuilder: (context, content, styleSheet, isUser) {
        return MarkdownBody(
          data: content,
          styleSheet: styleSheet,
          selectable: true,
        );
      },
      userTextColor: MihColors.primary(),
      aiTextColor: MihColors.primary(),
      aiNameIcon: Icon(
        MihIcons.ollama,
        color: MihColors.primary(),
      ),
      userNameStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: MihColors.primary(),
      ),
      userTimeTextStyle: TextStyle(
        fontSize: 12,
        color: MihColors.grey(darkMode: false),
      ),
      aiTimeTextStyle: TextStyle(
        fontSize: 12,
        color: MihColors.grey(darkMode: false),
      ),
      bubbleStyle: BubbleStyle(
        userBubbleColor: MihColors.green(),
        aiBubbleColor: MihColors.secondary(),
      ),
      showCopyButton: true,
      copyButtonLabel: 'Copy',
      // copiedToClipboardText: 'Copied to clipboard!',
      onCopy: (text) {
        ScaffoldMessenger.of(context).showSnackBar(
          MihSnackBar(
            child: const Text("Copied to clipboard!"),
          ),
        );
      },
    );
  }

  WelcomeMessageConfig getWelcomeMessageConfig(
    String name,
    double width,
    BuildContext context,
  ) {
    return WelcomeMessageConfig(
      centerVertically: true,
      title: "Hi There $name 👋\nMzansi AI is here to help.",
      titleStyle: TextStyle(
        fontSize: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? 35
            : 24,
        fontWeight: FontWeight.bold,
        color: MihColors.primary(),
      ),
      containerDecoration: BoxDecoration(
        color: MihColors.secondary(),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      containerMargin: EdgeInsets.symmetric(
          horizontal:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? width * 0.2
                  : width * 0.07,
          vertical: 20),
      containerPadding: const EdgeInsets.all(20),
      questionsSectionTitleStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: MihColors.secondary(),
      ),
      questionsSectionDecoration: BoxDecoration(
        color: MihColors.primary().withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      questionsSectionPadding: const EdgeInsets.all(12),
      questionSpacing: 8.0,
      // centerVertically: true,
    );
  }

  ExampleQuestionConfig getExampleQuestionCOnfig() {
    return ExampleQuestionConfig(
      textStyle: TextStyle(
        color: MihColors.secondary(), // Your text color here
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      containerDecoration: BoxDecoration(
        color: MihColors.primary(),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      containerPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
// Leading Icon (Left side)
      iconData: Icons.chat_bubble_outline_rounded,
      iconColor: MihColors.secondary(),
      iconSize: 18.0,

      // Trailing Icon (Right side)
      trailingIconData: Icons.arrow_forward_rounded,
      trailingIconColor: MihColors.secondary(),
      trailingIconSize: 18.0,

      spacing: 12.0,
    );
  }

  LoadingConfig getLoadingConfig(
    bool isLoading,
    bool isTalking,
  ) {
    return LoadingConfig(
      isLoading: isLoading,
      loadingIndicator: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 20),
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(MihColors.secondary()),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              isTalking ? "Talking..." : "Thinking...",
              style: TextStyle(
                color: MihColors.secondary(),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ScrollToBottomOptions getScrollToBottomOptions() {
    return ScrollToBottomOptions(
      bottomOffset: 80,
      rightOffset: 16,
      scrollToBottomBuilder: (scrollController) {
        return Positioned(
          bottom: 80,
          right: 16,
          child: FloatingActionButton.small(
            backgroundColor: MihColors.secondary(),
            foregroundColor: MihColors.primary(),
            onPressed: () {
              scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            child: const Icon(Icons.arrow_downward_rounded),
          ),
        );
      },
    );
  }

  MarkdownStyleSheet getMarkdownStyleSheet() {
    return MarkdownStyleSheet(
      // Paragraph & Body Text
      p: TextStyle(
        color: MihColors.primary(),
        fontSize: 15,
        height: 1.45,
      ),
      strong: TextStyle(
        color: MihColors.primary(),
        fontWeight: FontWeight.bold,
      ),
      em: TextStyle(
        color: MihColors.primary(),
        fontStyle: FontStyle.italic,
      ),
      del: TextStyle(
        color: MihColors.primary().withOpacity(0.6),
        decoration: TextDecoration.lineThrough,
      ),
      a: TextStyle(
        color: MihColors.bluishPurple(),
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w600,
      ),

      h1: TextStyle(
        color: MihColors.primary(),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.5,
      ),
      h1Padding: const EdgeInsets.only(top: 8, bottom: 4),
      h2: TextStyle(
        color: MihColors.primary(),
        fontSize: 18,
        fontWeight: FontWeight.bold,
        height: 1.4,
      ),
      h2Padding: const EdgeInsets.only(top: 8, bottom: 4),
      h3: TextStyle(
        color: MihColors.primary(),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      h3Padding: const EdgeInsets.only(top: 6, bottom: 2),

      listBullet: TextStyle(
        color: MihColors.primary(),
        fontSize: 15,
      ),
      listIndent: 20,

      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: MihColors.primary().withOpacity(0.15)),
        ),
      ),

      code: TextStyle(
        color: MihColors.green(darkMode: false),
        backgroundColor: Colors.transparent,
        fontFamily: 'monospace',
        fontSize: 13.5,
        fontWeight: FontWeight.bold,
      ),
      codeblockDecoration: BoxDecoration(
        color: const Color(0xFF1B1D28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: MihColors.primary().withOpacity(0.15),
        ),
      ),
      codeblockPadding: const EdgeInsets.all(12),
      blockquote: TextStyle(
        color: MihColors.primary().withOpacity(0.85),
        fontStyle: FontStyle.italic,
      ),
      blockquoteDecoration: BoxDecoration(
        color: MihColors.primary().withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: MihColors.green(),
            width: 4,
          ),
        ),
      ),
      blockquotePadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      tableBody: TextStyle(
        color: MihColors.primary(),
        fontSize: 14,
      ),
      tableHead: TextStyle(
        color: MihColors.primary(),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      tableBorder: TableBorder.all(
        color: MihColors.primary().withOpacity(0.2),
        width: 1,
      ),
      tableCellsPadding: const EdgeInsets.all(8),
    );
  }
}
