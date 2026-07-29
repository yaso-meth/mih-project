import 'package:web/web.dart' as web;

void openWebWindow(String url, [String? target]) {
  if (target != null) {
    web.window.open(url, target);
  } else {
    web.window.open(url);
  }
}

bool isWebStandalone() {
  return web.window.matchMedia('(display-mode: standalone)').matches;
}
