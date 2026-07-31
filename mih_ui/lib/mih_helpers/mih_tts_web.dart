import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

web.SpeechSynthesisUtterance? _activeUtterance;

void speakOnWeb(String text, {bool enqueue = false}) {
  if (text.trim().isEmpty) return;

  final synth = web.window.speechSynthesis;

  if (synth.paused) {
    synth.resume();
  }

  if (!enqueue) {
    synth.cancel();
  }

  _activeUtterance = web.SpeechSynthesisUtterance(text);

  synth.speak(_activeUtterance!);
}

void stopOnWeb() {
  if (kIsWasm) {
    web.window.speechSynthesis.cancel();
  }
}

void unlockWebAudio() {
  if (kIsWasm) {
    final synth = web.window.speechSynthesis;
    synth.resume();
    synth.speak(web.SpeechSynthesisUtterance(' '));
  }
}
