import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;

class WebviewWidget extends StatefulWidget {
  const WebviewWidget({Key? key}) : super(key: key);

  @override
  WebviewWidgetState createState() => WebviewWidgetState();
}

class WebviewWidgetState extends State<WebviewWidget> {
  double currentDownloading = 0;
  late WebViewController controller;

  // @override
  // void initState() async {
  //   super.initState();

  // if (Platform.isAndroid) {
  //   WebView.platform = SurfaceAndroidWebView();
  // }
  // }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..runJavaScriptReturningResult(javaScript)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/choose-file-url')) {
              pickFile();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onProgress: (int progress) {
            setState(() {
              currentDownloading = progress / 100;
            });
          },
          //   onPageStarted: (String url) {},
          //   onPageFinished: (String url) {},
          //   onWebResourceError: (WebResourceError error) {},
          //  navigationDelegate: (NavigationRequest request) {
          //         if (request.url.contains('/choose-file-url')) {
          //           pickFile();
          //           return NavigationDecision.prevent;
          //         }
          //         return NavigationDecision.navigate;
          //       },
        ),
      )
      ..loadRequest(
        Uri.parse(
            'https://pagbeting.space/QN9Kbb?gaid=131568a1-9fd6-4f5d-8633-901ee09d5e1a&token=ee1fOXnASpeBy75wDa9AEk:APA81bE411bx_KPYogvBP-3vhYO5LNYyDy6k9C6FbJyvGfyv_VZwX3hI2TkvzHXejEB-k40B06lVaaXHEc6N-aX8Z15HNooNa0_hxOMj1gmMJWmYzsbqP0I8BXjaLyS0vrFrQo8GGiqo&name=Alexander_Kuzetov'
            // 'http://info.cern.ch'
            // 'https://www.youtube.com/',
            ),
      );

    if (Platform.isAndroid) {
      final controllerPlatform = (controller.platform
          as webview_flutter_android.AndroidWebViewController);
      await controllerPlatform.setOnShowFileSelector(pickFile
          as Future<List<String>> Function(
              webview_flutter_android.FileSelectorParams params)?);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: currentDownloading,
              color: Colors.blue.shade300,
              backgroundColor: Colors.black,
            ),
            Expanded(
              child: WebViewWidget(controller: controller),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        backgroundColor: Colors.red,
        child: const Icon(Icons.keyboard_backspace_outlined),
      ),
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      print('Обработка');
    }
  }
}
