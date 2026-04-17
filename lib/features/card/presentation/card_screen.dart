import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/providers/card_providers.dart';
import 'widgets/knowledge_card_widget.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────

const Color _bg        = Color(0xFF06161A);
const Color _cardDark  = Color(0xFF112226);
const Color _border    = Color(0xFF2D4A4A);
const Color _primary   = Color(0xFF00D084);

// ─── Category meta ────────────────────────────────────────────────────────────

const _allCategories = [
  'science',
  'geography',
  'history',
  'sport',
  'entertainment',
  'events',
];

String _categoryLabel(String cat) {
  switch (cat) {
    case 'science':       return 'Science';
    case 'geography':     return 'Geography';
    case 'history':       return 'History';
    case 'sport':         return 'Sport';
    case 'entertainment': return 'Entertainment';
    case 'events':        return 'Events';
    default:              return cat;
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class CardScreen extends ConsumerWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards        = ref.watch(filteredCardsProvider);
    final counts       = ref.watch(cardCountsByCategoryProvider);
    final totalCount   = ref.watch(allKnowledgeCardsProvider).length;
    final activeFilter = ref.watch(cardCategoryFilterProvider);
    final sortOrder    = ref.watch(cardSortOrderProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top bar ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  // Title + count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Cards',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$totalCount cards collected',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Sort button
                  GestureDetector(
                    onTap: () => _showSortSheet(context, ref, sortOrder),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: _cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sort_rounded,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _shortSortLabel(sortOrder),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Filter chips ───────────────────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  // "All" chip
                  _FilterChip(
                    label: 'All',
                    count: totalCount,
                    selected: activeFilter == null,
                    onTap: () => ref
                        .read(cardCategoryFilterProvider.notifier)
                        .state = null,
                  ),
                  const SizedBox(width: 8),
                  // Per-category chips (only categories that have ≥1 card)
                  for (final cat in _allCategories)
                    if ((counts[cat] ?? 0) > 0) ...[
                      _FilterChip(
                        label: _categoryLabel(cat),
                        count: counts[cat]!,
                        selected: activeFilter == cat,
                        onTap: () => ref
                            .read(cardCategoryFilterProvider.notifier)
                            .state = cat,
                      ),
                      const SizedBox(width: 8),
                    ],
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Card grid ──────────────────────────────────────────────────
            Expanded(
              child: cards.isEmpty
                  ? _EmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.68,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) => KnowledgeCardWidget(
                        key: ValueKey(cards[index].id),
                        card: cards[index],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Sort bottom sheet ──────────────────────────────────────────────────────

  void _showSortSheet(
    BuildContext context,
    WidgetRef ref,
    CardSortOrder current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _SortSheet(current: current, ref: ref),
    );
  }
}

// ─── Filter chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withValues(alpha: 0.15)
              : _cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _primary : _border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? _primary : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: selected
                    ? _primary.withValues(alpha: 0.20)
                    : Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: selected ? _primary : const Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sort bottom sheet ────────────────────────────────────────────────────────

class _SortSheet extends StatelessWidget {
  const _SortSheet({required this.current, required this.ref});

  final CardSortOrder current;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D2226),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Sort Cards',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          for (final order in CardSortOrder.values) ...[
            _SortOption(
              label: order.label,
              selected: current == order,
              onTap: () {
                ref.read(cardSortOrderProvider.notifier).state = order;
                Navigator.of(context).pop();
              },
            ),
            if (order != CardSortOrder.values.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? _primary.withValues(alpha: 0.12)
              : _cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _primary.withValues(alpha: 0.50) : _border,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? _primary : Colors.white,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                size: 18,
                color: _primary,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.style_rounded,
            size: 52,
            color: Colors.white.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 14),
          const Text(
            'No cards found',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Play quiz modes to earn knowledge cards',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

String _shortSortLabel(CardSortOrder order) {
  switch (order) {
    case CardSortOrder.newest:     return 'Newest';
    case CardSortOrder.rarityHigh: return 'Rarity ↓';
    case CardSortOrder.rarityLow:  return 'Rarity ↑';
    case CardSortOrder.categoryAZ: return 'Category';
  }
}
