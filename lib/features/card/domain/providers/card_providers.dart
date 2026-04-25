import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/knowledge_card_model.dart';
import '../../data/services/mock/mock_card_service.dart';

// ─── Sort order ───────────────────────────────────────────────────────────────

enum CardSortOrder {
  newest('Newest First'),
  rarityHigh('Rarity: Highest First'),
  rarityLow('Rarity: Lowest First'),
  categoryAZ('Category A–Z');

  const CardSortOrder(this.label);
  final String label;
}

// ─── State providers ──────────────────────────────────────────────────────────

/// Currently selected category filter. `null` = All.
final cardCategoryFilterProvider = StateProvider<String?>((ref) => null);

/// Current sort order.
final cardSortOrderProvider =
    StateProvider<CardSortOrder>((ref) => CardSortOrder.newest);

// ─── Data providers ───────────────────────────────────────────────────────────

/// All cards the user owns (mock for now).
final allKnowledgeCardsProvider = Provider<List<KnowledgeCardModel>>(
  (ref) => MockCardService.allCards,
);

/// Cards after applying category filter + sort.
final filteredCardsProvider = Provider<List<KnowledgeCardModel>>((ref) {
  final all      = ref.watch(allKnowledgeCardsProvider);
  final category = ref.watch(cardCategoryFilterProvider);
  final sort     = ref.watch(cardSortOrderProvider);

  var list = category == null
      ? List<KnowledgeCardModel>.from(all)
      : all.where((c) => c.category == category).toList();

  switch (sort) {
    case CardSortOrder.newest:
      list.sort((a, b) => b.earnedAt.compareTo(a.earnedAt));
    case CardSortOrder.rarityHigh:
      list.sort((a, b) => b.rarity.index.compareTo(a.rarity.index));
    case CardSortOrder.rarityLow:
      list.sort((a, b) => a.rarity.index.compareTo(b.rarity.index));
    case CardSortOrder.categoryAZ:
      list.sort((a, b) => a.category.compareTo(b.category));
  }

  return list;
});

/// Count of cards per category (for chip badges).
final cardCountsByCategoryProvider = Provider<Map<String, int>>((ref) {
  final all = ref.watch(allKnowledgeCardsProvider);
  final counts = <String, int>{};
  for (final card in all) {
    counts[card.category] = (counts[card.category] ?? 0) + 1;
  }
  return counts;
});
