import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Roadmap extends StatefulWidget {
  const Roadmap({super.key});

  @override
  State<Roadmap> createState() => _RoadmapState();

}

class _RoadmapState extends State<Roadmap> {
  final controller = WebViewController();
  bool isLoading = true;



  @override
  void initState() {
  super.initState();
  controller
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://neetcode.io/roadmap')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
  ..loadRequest(Uri.parse('https://neetcode.io/roadmap'));
  }

  Widget build(BuildContext context) {
  return Scaffold(
    body: WebViewWidget(controller: controller,),
  );
}
}
