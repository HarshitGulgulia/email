import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../../../models/Email.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key key,
    this.email,
  }) : super(key: key);

  final Email email;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 7000,
      child: WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          await controller.loadString(widget.email.html);
        },
      ),
    );
  }
}
