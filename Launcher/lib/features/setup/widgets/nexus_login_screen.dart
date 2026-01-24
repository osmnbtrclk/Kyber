import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kyber_launcher/core/services/notification_service.dart';
import 'package:kyber_launcher/features/nexusmods/services/nexusmods_service.dart';
import 'package:kyber_launcher/injection_container.dart';
import 'package:kyber_launcher/main.dart';
import 'package:logging/logging.dart';

class NexusLoginScreen extends StatefulWidget {
  const NexusLoginScreen({
    required this.onShowOverlay,
    required this.onSuccess,
    super.key,
  });

  final void Function(bool showOverlay) onShowOverlay;
  final void Function() onSuccess;

  @override
  State<NexusLoginScreen> createState() => _NexusLoginScreenState();
}

class _NexusLoginScreenState extends State<NexusLoginScreen> {
  InAppWebViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialUrlRequest: URLRequest(
        url: WebUri('https://users.nexusmods.com/auth/sign_in'),
      ),
      initialSettings: InAppWebViewSettings(
        forceDark: ForceDark.ON,
        isInspectable: true,
      ),
      onWebViewCreated: (controller) async {
        await CookieManager.instance(
          webViewEnvironment: webViewEnvironment,
        ).deleteAllCookies();
      },
      onLoadStart: (controller, url) async {
        final uri = url.toString();

        if (uri.startsWith('https://users.nexusmods.com')) {
          widget.onShowOverlay(true);
          return;
        }
      },
      onReceivedHttpError: (controller, request, errorResponse) {
        if (!mounted) return;
        widget.onShowOverlay(false);

        if (errorResponse.contentType != 'text/html') {
          NotificationService.error(
            message:
                'An error occurred while loading the page. Please try again later.',
          );
          return;
        }

        Logger.root.severe(
          'http error: ${String.fromCharCodes(errorResponse.data ?? [])} (code: ${errorResponse.statusCode}, url: ${request.url})',
        );
      },
      onLoadStop: (controller, url) async {
        if (!mounted) return;

        final uri = url.toString();
        if (uri.startsWith('https://users.nexusmods.com/account') ||
            uri.startsWith('https://users.nexusmods.com/account/security')) {
          widget.onShowOverlay(true);
          await controller.loadUrl(
            urlRequest: URLRequest(
              url: WebUri('https://www.nexusmods.com/starwarsbattlefront22017'),
            ),
          );
          return;
        }

        if (uri.startsWith('https://users.nexusmods.com/auth') ||
            uri.startsWith('https://users.nexusmods.com/register')) {
          widget.onShowOverlay(false);
          return;
        }

        if (uri.startsWith(
          'https://www.nexusmods.com/games/starwarsbattlefront22017',
        )) {
          await sl.get<NexusModsService>().requestApiToken(
            onUrl: (url) => controller.loadUrl(
              urlRequest: URLRequest(url: WebUri(url)),
            ),
          );
          widget.onSuccess();
        }

        if (uri.startsWith('https://www.nexusmods.com/sso')) {
          await controller.evaluateJavascript(
            source:
                '''document.getElementsByClassName('hero-overlay')[0].scrollIntoView();''',
          );
          widget.onShowOverlay(false);
          return;
        }
      },
    );
  }
}
