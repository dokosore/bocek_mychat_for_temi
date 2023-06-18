import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);
  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      final microphoneStatus = await Permission.microphone.status;
      final videoStatus = await Permission.camera.status;

      if (microphoneStatus.isDenied || videoStatus.isDenied) {
        print("許可取得開始");
        await Permission.microphone.request();
        await Permission.camera.request();
        print("許可が得られませんでした");
      } else {
        print("許可が得られました");
      }
    });
  }

  final webviewUrl = 'https://mychat.bocek.co.jp/';

  final javascript = '''
     navigator.mediaDevices.getUserMedia({ audio: true, video: true })
      .then(function(stream) {
        // マイクの許可が得られた場合の処理
        alert("マイク許可取得成功");
      })
      .catch(function(error) {
        // マイクの許可が拒否された場合の処理
        alert(error);
        // alert(`マイク許可取得失敗`);
      });
  ''';

  late WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(webviewUrl))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          if (progress == 100) {
            controller.runJavaScript(javascript);
          }
        },
      ),
    );

  @override
  Widget build(BuildContext context) {
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    return Scaffold(body: WebViewWidget(controller: controller));
  }
}
