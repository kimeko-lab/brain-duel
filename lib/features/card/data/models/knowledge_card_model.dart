import 'package:flutter/material.dart';

// ─── Rarity ───────────────────────────────────────────────────────────────────

enum CardRarity {
  common,    // 1 ★
  uncommon,  // 2 ★
  rare,      // 3 ★
  legendary, // 4 ★
  unique;    // 5 ★

  /// Number of filled stars shown on the card.
  int get stars => index + 1;

  String get label {
    switch (this) {
      case common:    return 'Common';
      case uncommon:  return 'Uncommon';
      case rare:      return 'Rare';
      case legendary: return 'Legendary';
      case unique:    return 'Unique';
    }
  }

  Color get color {
    switch (this) {
      case common:    return const Color(0xFF9CA3AF); // gray
      case uncommon:  return const Color(0xFF00D084); // green
      case rare:      return const Color(0xFF0EA5E9); // blue
      case legendary: return const Color(0xFFFBBF24); // gold
      case unique:    return const Color(0xFFA855F7); // purple
    }
  }
}

// ─── Model ────────────────────────────────────────────────────────────────────

@immutable
class KnowledgeCardModel {
  const KnowledgeCardModel({
    required this.id,
    required this.category,
    required this.rarity,
    required this.question,
    required this.answer,
    required this.earnedAt,
  });

  final String id;
  final String category; // 'science', 'geography', 'history', 'sport', 'entertainment', 'events'
  final CardRarity rarity;
  final String question;
  final String answer;
  final DateTime earnedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is KnowledgeCardModel && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
