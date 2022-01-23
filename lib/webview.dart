import 'package:flutter/material.dart';
import 'package:mental_health/webview_stack.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mental_health/navigation_controls.dart';
import 'dart:io';
import 'dart:async';

/// https://codelabs.developers.google.com/codelabs/flutter-webview
class WebViewApp extends StatefulWidget {
  final String title;
  final String url;

  const WebViewApp({required this.title, required this.url, Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final controller = Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebViewStack(url: widget.url, controller: controller)
    );
  }
}