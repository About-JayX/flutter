import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobisen_app/util/view_utils.dart';

class WebView extends StatelessWidget {
  final String? url;
  final String? title;
  const WebView({
    super.key,
    this.url,
    this.title,
  });

  // ensure URL contains protocol
  String _ensureUrlHasScheme(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'https://$url';
  }

  @override
  Widget build(BuildContext context) {
    final String fullUrl = _ensureUrlHasScheme(url ?? '');
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(fullUrl));

    return Scaffold(
      appBar: ViewUtils.buildCommonAppBar(
        context,
        title: Text(title ?? ''),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
