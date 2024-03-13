import 'package:flutter/material.dart';

class SplashScerrn extends StatelessWidget {
  const SplashScerrn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('personal screen'),
      ),
      body: const Center(
        child: Text('Loading.....'),
      ),
    );
  }
}
