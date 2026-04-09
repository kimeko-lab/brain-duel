import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DailyClassicGameScreen extends StatelessWidget {
  const DailyClassicGameScreen({super.key, required this.category});

  final String category;

  static DailyClassicGameScreen fromState(
          BuildContext context, GoRouterState state) =>
      DailyClassicGameScreen(
        category: state.pathParameters['category'] ?? '',
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Classic')),
      body: Center(
        child: Text(category),
      ),
    );
  }
}
