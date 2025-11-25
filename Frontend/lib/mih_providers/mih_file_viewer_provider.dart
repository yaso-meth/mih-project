import 'package:flutter/material.dart';

class MihFileViewerProvider extends ChangeNotifier {
  String filePath;
  String fileLink;
  int toolIndex;

  MihFileViewerProvider({
    this.filePath = '',
    this.fileLink = '',
    this.toolIndex = 0,
  });

  void setToolIndex(int index) {
    toolIndex = index;
    notifyListeners();
  }

  void setFilePath(String path) {
    filePath = path;
    notifyListeners();
  }

  void setFileLink(String name) {
    fileLink = name;
    notifyListeners();
  }
}
