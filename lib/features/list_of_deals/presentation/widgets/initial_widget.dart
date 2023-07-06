import 'package:flutter/material.dart';

class InitialWidget extends StatelessWidget {
  const InitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(widthScreen * 0.03),
      child: const Center(
        child: Text(
          'Все решает кнопочка)',
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}
