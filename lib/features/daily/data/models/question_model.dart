import 'package:flutter/foundation.dart';

enum QuestionRarity { common, rare, unique, legendary }

@immutable
class QuestionModel {
  final String id;
  final String category;   // e.g. 'science', 'geography'
  final QuestionRarity rarity;
  final String text;
  final List<String> options;  // exactly 4 items for MC4
  final int correctIndex;      // 0–3

  const QuestionModel({
    required this.id,
    required this.category,
    required this.rarity,
    required this.text,
    required this.options,
    required this.correctIndex,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModel &&
          id == other.id &&
          category == other.category &&
          rarity == other.rarity &&
          text == other.text &&
          correctIndex == other.correctIndex;

  @override
  int get hashCode => Object.hash(id, category, rarity, text, correctIndex);

  QuestionModel copyWith({
    String? id,
    String? category,
    QuestionRarity? rarity,
    String? text,
    List<String>? options,
    int? correctIndex,
  }) => QuestionModel(
        id: id ?? this.id,
        category: category ?? this.category,
        rarity: rarity ?? this.rarity,
        text: text ?? this.text,
        options: options ?? this.options,
        correctIndex: correctIndex ?? this.correctIndex,
      );
}
