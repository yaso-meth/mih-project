// Create this file anywhere, e.g., lib/mih_config/mih_web_utils_stub.dart
void openWebWindow(String url, [String? target]) {
  // Safe no-op or fallback on Linux (e.g., could use url_launcher if needed)
}

bool isWebStandalone() {
  return false; // Always false on native Linux app
}
