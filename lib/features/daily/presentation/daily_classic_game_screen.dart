import 'package:flutter/material.dart';

class DailyClassicGameScreen extends StatelessWidget {
  const DailyClassicGameScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game — $category')),
      body: Center(child: Text('Category: $category')),
    );
  }
}
