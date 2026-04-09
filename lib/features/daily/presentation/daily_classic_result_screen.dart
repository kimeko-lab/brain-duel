import 'package:flutter/material.dart';

class DailyClassicResultScreen extends StatelessWidget {
  const DailyClassicResultScreen({super.key, required this.extra});

  final Map<String, dynamic> extra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: const Center(
        child: Text('Result — coming soon'),
      ),
    );
  }
}
