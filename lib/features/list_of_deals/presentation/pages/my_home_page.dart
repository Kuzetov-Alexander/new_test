import 'package:flutter/material.dart';
import 'package:new_test/features/list_of_deals/presentation/widgets/card_widget.dart';
import 'package:new_test/features/list_of_deals/presentation/widgets/initial_widget.dart';
// import 'package:new_test/features/list_of_deals/presentation/widgets/webview_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(115, 174, 171, 171),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            return const InitialWidget();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const CardWidget(),
              // builder: (BuildContext context) => const WebviewWidget(),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }
}
