import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);
  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  void initState() async {
    super.initState();
    final status = await Permission.microphone.status;
    if (status.isDenied) {
      print("マイクの許可が得られませんでした");
      await Permission.microphone.request();
    } else {
      print("マイクの許可が得られました");
    }
  }

  final webviewUrl = 'https://mychat.bocek.co.jp/';

  final javascript = '''
     navigator.mediaDevices.getUserMedia({ audio: true })
      .then(function(stream) {
        // マイクの許可が得られた場合の処理
        alert("test1");
      })
      .catch(function(error) {
        // マイクの許可が拒否された場合の処理
        alert("test2");
      });
  ''';

  late WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..loadRequest(Uri.parse(webviewUrl))
    ..runJavaScript(javascript);

  double progress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
