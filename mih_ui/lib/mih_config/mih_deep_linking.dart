import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';

class MihDeepLink {
  static final AppLinks _appLinks = AppLinks();
  static StreamSubscription<Uri>? _linkSubscription;

  static void init(GoRouter router) {
    _linkSubscription?.cancel();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        KenLogger.success("Deep link received: $uri");
        _handleDeepLink(uri, router);
      },
      onError: (Object err) {
        KenLogger.error("Deep link error: $err");
      },
    );
  }

  static void _handleDeepLink(Uri uri, GoRouter router) {
    String routePath = uri.path;

    if (uri.scheme == 'mih' && uri.host.isNotEmpty) {
      routePath = '/${uri.host}$routePath';
    }

    if (routePath.isEmpty) {
      routePath = '/';
    } else if (!routePath.startsWith('/')) {
      routePath = '/$routePath';
    }

    final String fullLocation =
        uri.hasQuery ? '$routePath?${uri.query}' : routePath;

    KenLogger.success("Navigating via GoRouter to: $fullLocation");

    router.go(fullLocation);
  }

  static void dispose() {
    _linkSubscription?.cancel();
  }
}
