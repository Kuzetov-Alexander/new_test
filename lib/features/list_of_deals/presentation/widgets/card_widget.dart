import 'dart:io';
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;

class CardWidget extends StatefulWidget {
  const CardWidget({super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  double currentDownloading = 0;
  late final WebViewController controller;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // ..runJavaScriptReturningResult(javaScript)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              currentDownloading = progress / 100;
            });
          },
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
      await controllerPlatform.setOnShowFileSelector(_androidFilePicker);
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
              child: WebViewWidget(
                controller: controller,
              ),
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
}

Future<List<String>> _androidFilePicker(
    webview_flutter_android.FileSelectorParams params) async {
  if (params.acceptTypes.any((type) => type == 'image/*')) {
    final picker = image_picker.ImagePicker();
    final photo =
        await picker.pickImage(source: image_picker.ImageSource.camera);

    if (photo == null) {
      return [];
    }

    final imageData = await photo.readAsBytes();
    final decodedImage = image.decodeImage(imageData)!;
    final scaledImage = image.copyResize(decodedImage, width: 500);
    final jpg = image.encodeJpg(scaledImage, quality: 90);

    final filePath = (await getTemporaryDirectory()).uri.resolve(
          './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
    final file = await File.fromUri(filePath).create(recursive: true);
    await file.writeAsBytes(jpg, flush: true);

    return [file.uri.toString()];
  }

  return [];
}
