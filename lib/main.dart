import 'package:care/styles/theme.dart';
import 'package:care/styles/typos.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '위듀 케어',
      theme: MyTheme.myTheme,
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '위듀 케어 앱',
          style: MyTypo.body1,
        ),
      ),
    );
  }
}
