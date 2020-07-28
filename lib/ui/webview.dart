import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'extension/widget_extension.dart';

class WebViewContent extends StatefulWidget {
  final ModelEntity entity;

  WebViewContent({@required this.entity});

  @override
  State<StatefulWidget> createState() => WebViewState();
}

class WebViewState extends State<WebViewContent> {
  final _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPopCallback(),
      child: Scaffold(
        appBar: buildAppBar(widget.entity.name),
        body: WebView(
          initialUrl: widget.entity.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    var webViewController = await _controller.future;
    var gotBackStack = await webViewController.canGoBack();
    if (gotBackStack) {
      await webViewController.goBack();
      return false;
    }
    return true;
  }
}
