import 'package:flutter/material.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

///
/// Define for Terms & Conditions
///  @author Balaji Sundaram 21/06/2022.
///  @version 1.0
///
class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorData.kcPrimaryDarkColor,
        title: const Text('')
      ),
        body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadUrl('assets/images/index.html');
          },
        ));
  }
}