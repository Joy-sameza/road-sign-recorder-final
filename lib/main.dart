import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const RoadSignsRecorderApp());
}

class RoadSignsRecorderApp extends StatelessWidget {
  const RoadSignsRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Signs Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
