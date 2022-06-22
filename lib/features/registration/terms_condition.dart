import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class TermsAndConditionScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('')
      ),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadUrl('images/index.html');
          },
        ));
  }
}