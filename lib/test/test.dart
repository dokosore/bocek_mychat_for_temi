import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

class WebTestPage extends StatefulWidget {
  const WebTestPage({Key? key}) : super(key: key);
  @override
  State<WebTestPage> createState() => _WebTestPageState();
}

class _WebTestPageState extends State<WebTestPage> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );

  Future<void> getPermission() async {
    final microphoneStatus = await Permission.microphone.status;
    final videoStatus = await Permission.camera.status;

    if (microphoneStatus.isDenied || videoStatus.isDenied) {
      await Permission.microphone.request();
      await Permission.camera.request();
    } else {
      print("許可が得られました");
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  final webviewUrl = 'https://mychat.bocek.co.jp/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialSettings: settings,
        key: webViewKey,
        initialUrlRequest: URLRequest(url: WebUri(webviewUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
        onProgressChanged: (controller, progress) {
          if (progress == 100) {
            getPermission();
          }
        },
      ),
    );
  }
}
