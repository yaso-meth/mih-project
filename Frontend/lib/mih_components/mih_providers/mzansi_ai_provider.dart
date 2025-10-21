import 'package:flutter/material.dart';

class MzansiAiProvider extends ChangeNotifier {
  int toolIndex;
  String? startUpQuestion;

  MzansiAiProvider({
    this.toolIndex = 0,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setStartUpQuestion(String? question) {
    startUpQuestion = question;
    notifyListeners();
  }
}
