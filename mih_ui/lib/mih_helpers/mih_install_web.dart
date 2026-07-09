import 'dart:js_interop';

@JS('promptInstall')
external void jsPromptInstall();

@JS('isInstallPromptAvailable')
external bool jsIsInstallPromptAvailable();

void triggerWebInstall() {
  if (jsIsInstallPromptAvailable()) {
    jsPromptInstall();
  }
}
