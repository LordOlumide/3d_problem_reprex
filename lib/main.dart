import 'package:flutter/material.dart';
import 'package:problem_reprex/home_screen.dart';
import 'package:problem_reprex/home_screen_2.dart';
import 'package:problem_reprex/home_screen_3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen3(),
    );
  }
}
