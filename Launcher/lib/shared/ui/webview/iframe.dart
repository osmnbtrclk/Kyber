import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kyber_launcher/main.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Iframe extends StatefulWidget {
  const Iframe({this.url, this.data, super.key});

  final String? url;
  final String? data;

  @override
  State<Iframe> createState() => _IframeState();
}

class _IframeState extends State<Iframe> {
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialData: widget.data != null
          ? InAppWebViewInitialData(data: widget.data!)
          : null,
      initialUrlRequest: widget.url != null
          ? URLRequest(url: WebUri(widget.url!))
          : null,
      initialSettings: InAppWebViewSettings(
        forceDark: ForceDark.ON,
        useShouldOverrideUrlLoading: true,
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) {
        if (!loaded) {
          return NavigationActionPolicy.ALLOW;
        }

        launchUrlString(navigationAction.request.url.toString());
        return NavigationActionPolicy.CANCEL;
      },
      onLoadStop: (controller, url) => loaded = true,
    );
  }
}
