import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../card/data/models/knowledge_card_model.dart';
import '../../card/presentation/widgets/knowledge_card_widget.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────

const Color _bg       = Color(0xFF06161A);
const Color _card     = Color(0xFF0D2226);
const Color _border   = Color(0xFF2D4A4A);
const Color _primary  = Color(0xFF00D084);

const Color _silver = Color(0xFFCBD5E1);
const Color _gold   = Color(0xFFFBBF24);
const Color _event  = Color(0xFFA855F7);

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildTabBar(),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                physics: const NeverScrollableScrollPhysics(),
                children: const [_OffersTab(), _CardsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Power up your collection',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const Spacer(),
          _CurrencyPill(
              icon: Icons.menu_book_rounded, color: _silver, amount: 150),
          const SizedBox(width: 6),
          _CurrencyPill(
              icon: Icons.auto_stories_rounded, color: _gold, amount: 12),
          const SizedBox(width: 6),
          _CurrencyPill(
              icon: Icons.auto_awesome_rounded, color: _event, amount: 3),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _TabChip(
            label: 'Offers',
            index: 0,
            current: _tabs.index,
            onTap: () => _tabs.animateTo(0),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Knowledge Cards',
            index: 1,
            current: _tabs.index,
            onTap: () => _tabs.animateTo(1),
          ),
        ],
      ),
    );
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _CurrencyPill extends StatelessWidget {
  const _CurrencyPill(
      {required this.icon, required this.color, required this.amount});

  final IconData icon;
  final Color color;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '$amount',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  final String label;
  final int index, current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sel = index == current;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: sel ? _primary.withValues(alpha: 0.14) : _card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: sel ? _primary : _border,
            width: sel ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: sel ? _primary : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// OFFERS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _OffersTab extends StatelessWidget {
  const _OffersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        // ── Monthly Pass ────────────────────────────────────────────────
        const _MonthlyPassBanner(),
        const SizedBox(height: 22),

        // ── Silver Books ─────────────────────────────────────────────────
        const _SectionHeader(
          icon: Icons.menu_book_rounded,
          color: _silver,
          title: 'SILVER BOOKS',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _BookBundle(
                icon: Icons.menu_book_rounded,
                iconColor: _silver,
                bgColors: const [Color(0xFF1E2A38), Color(0xFF111C26)],
                amount: 80,
                bonusAmount: 0,
                price: r'$4.99',
                highlight: null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BookBundle(
                icon: Icons.menu_book_rounded,
                iconColor: _silver,
                bgColors: const [Color(0xFF1E2A38), Color(0xFF111C26)],
                amount: 200,
                bonusAmount: 20,
                price: r'$9.99',
                highlight: 'POPULAR',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BookBundle(
                icon: Icons.menu_book_rounded,
                iconColor: _silver,
                bgColors: const [Color(0xFF1E2A38), Color(0xFF111C26)],
                amount: 500,
                bonusAmount: 100,
                price: r'$19.99',
                highlight: 'BEST VALUE',
              ),
            ),
          ],
        ),

        const SizedBox(height: 22),

        // ── Golden Books ─────────────────────────────────────────────────
        const _SectionHeader(
          icon: Icons.auto_stories_rounded,
          color: _gold,
          title: 'GOLDEN BOOKS',
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _BookBundle(
                icon: Icons.auto_stories_rounded,
                iconColor: _gold,
                bgColors: const [Color(0xFF2A1E08), Color(0xFF1A1005)],
                amount: 15,
                bonusAmount: 0,
                price: r'$4.99',
                highlight: null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BookBundle(
                icon: Icons.auto_stories_rounded,
                iconColor: _gold,
                bgColors: const [Color(0xFF2A1E08), Color(0xFF1A1005)],
                amount: 40,
                bonusAmount: 5,
                price: r'$9.99',
                highlight: 'POPULAR',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _BookBundle(
                icon: Icons.auto_stories_rounded,
                iconColor: _gold,
                bgColors: const [Color(0xFF2A1E08), Color(0xFF1A1005)],
                amount: 100,
                bonusAmount: 20,
                price: r'$19.99',
                highlight: 'BEST VALUE',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Monthly Pass Banner ──────────────────────────────────────────────────────

class _MonthlyPassBanner extends StatelessWidget {
  const _MonthlyPassBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B1F7A), Color(0xFF6D28D9), Color(0xFF92400E)],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFA855F7).withValues(alpha: 0.45),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
            blurRadius: 24,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // Subtle radial highlight top-left
            Positioned(
              top: -30,
              left: -20,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  // ── Left: badge + title + perks ───────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: _gold.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: _gold.withValues(alpha: 0.45)),
                              ),
                              child: const Text(
                                'MONTHLY PASS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  color: _gold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Brain Duel\nPass',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PassPerk(
                              icon: Icons.auto_stories_rounded,
                              color: _gold,
                              text: '5 Golden Books / day',
                            ),
                            const SizedBox(height: 4),
                            _PassPerk(
                              icon: Icons.style_rounded,
                              color: _event,
                              text: '1 Exclusive card back',
                            ),
                            const SizedBox(height: 4),
                            _PassPerk(
                              icon: Icons.menu_book_rounded,
                              color: _silver,
                              text: '200 Silver Books / month',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // ── Right: price + button ─────────────────────────────
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            r'$9.99',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          Text(
                            '/ month',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 11),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _gold.withValues(alpha: 0.45),
                              blurRadius: 14,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: const Text(
                          'SUBSCRIBE',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1C0A00),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassPerk extends StatelessWidget {
  const _PassPerk(
      {required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

// ─── Section header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(
      {required this.icon, required this.color, required this.title});

  final IconData icon;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 7),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            color: color.withValues(alpha: 0.20),
          ),
        ),
      ],
    );
  }
}

// ─── Book Bundle Card ─────────────────────────────────────────────────────────

class _BookBundle extends StatelessWidget {
  const _BookBundle({
    required this.icon,
    required this.iconColor,
    required this.bgColors,
    required this.amount,
    required this.bonusAmount,
    required this.price,
    required this.highlight,
  });

  final IconData icon;
  final Color iconColor;
  final List<Color> bgColors;
  final int amount;
  final int bonusAmount;
  final String price;
  final String? highlight;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = highlight != null;
    final isPopular    = highlight == 'POPULAR';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: bgColors,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlighted
              ? iconColor.withValues(alpha: 0.45)
              : _border,
          width: isHighlighted ? 1.5 : 1.0,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.18),
                  blurRadius: 14,
                  spreadRadius: -2,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Highlight badge (top-right)
          if (isHighlighted)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isPopular
                        ? const Color(0xFF0EA5E9).withValues(alpha: 0.20)
                        : _primary.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isPopular
                          ? const Color(0xFF0EA5E9).withValues(alpha: 0.50)
                          : _primary.withValues(alpha: 0.50),
                    ),
                  ),
                  child: Text(
                    highlight!,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 7.5,
                      fontWeight: FontWeight.w800,
                      color: isPopular ? const Color(0xFF38BDF8) : _primary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              10,
              isHighlighted ? 30 : 14,
              10,
              12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon with glow
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withValues(alpha: 0.22),
                        blurRadius: 12,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
                const SizedBox(height: 8),

                // Amount
                Text(
                  '$amount',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),

                // Bonus
                SizedBox(
                  height: 16,
                  child: bonusAmount > 0
                      ? Text(
                          '+$bonusAmount bonus',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: _primary,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 8),

                // Price button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [iconColor, iconColor.withValues(alpha: 0.75)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withValues(alpha: 0.30),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Text(
                    price,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// KNOWLEDGE CARDS TAB
// ─────────────────────────────────────────────────────────────────────────────

class _CardsTab extends StatelessWidget {
  const _CardsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: const [
        // ── Standard + Premium in a row ──────────────────────────────────
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _CardPullItem(
                  type: _PullType.silver,
                  title: 'STANDARD DRAW',
                  subtitle: 'Random Knowledge Card',
                  rarityRange: 'Common – Rare',
                  costIcon: Icons.menu_book_rounded,
                  costColor: _silver,
                  costLabel: '1 Silver Book',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _CardPullItem(
                  type: _PullType.gold,
                  title: 'PREMIUM DRAW',
                  subtitle: 'Enhanced Knowledge Card',
                  rarityRange: 'Uncommon – Unique',
                  costIcon: Icons.auto_stories_rounded,
                  costColor: _gold,
                  costLabel: '1 Golden Book',
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12),

        // ── Event Card — full width ───────────────────────────────────────
        _EventCardItem(),
      ],
    );
  }
}

// ─── Pull / draw types ────────────────────────────────────────────────────────

enum _PullType { silver, gold }

enum _DrawType { silver, gold, event }

KnowledgeCardModel _resultCard(_DrawType type) {
  switch (type) {
    case _DrawType.silver:
      return KnowledgeCardModel(
        id: 'result_silver',
        category: 'science',
        rarity: CardRarity.rare,
        question: 'What gas do plants absorb during photosynthesis?',
        answer: 'Carbon dioxide',
        earnedAt: DateTime(2026, 4, 17),
      );
    case _DrawType.gold:
      return KnowledgeCardModel(
        id: 'result_gold',
        category: 'entertainment',
        rarity: CardRarity.unique,
        question: 'Who composed the "Four Seasons" violin concertos?',
        answer: 'Antonio Vivaldi',
        earnedAt: DateTime(2026, 4, 17),
      );
    case _DrawType.event:
      return KnowledgeCardModel(
        id: 'result_event',
        category: 'events',
        rarity: CardRarity.unique,
        question:
            "In Dragon Ball Z, what is the name of Goku's most powerful "
            'Super Saiyan transformation introduced in Battle of Gods?',
        answer: 'Super Saiyan God',
        earnedAt: DateTime(2026, 4, 17),
      );
  }
}

void _openDrawReveal(BuildContext context, _DrawType type) {
  showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (ctx, a1, a2) =>
        _DrawRevealDialog(drawType: type, resultCard: _resultCard(type)),
  );
}

// ─── Standard / Premium card pull ────────────────────────────────────────────

class _CardPullItem extends StatefulWidget {
  const _CardPullItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.rarityRange,
    required this.costIcon,
    required this.costColor,
    required this.costLabel,
  });

  final _PullType type;
  final String title;
  final String subtitle;
  final String rarityRange;
  final IconData costIcon;
  final Color costColor;
  final String costLabel;

  @override
  State<_CardPullItem> createState() => _CardPullItemState();
}

class _CardPullItemState extends State<_CardPullItem>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _float;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    )..repeat(reverse: true);

    _float = Tween<double>(begin: -6.0, end: 6.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _glow = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  Color get _glowColor =>
      widget.type == _PullType.gold ? _gold : _silver;

  List<Color> get _cardColors => widget.type == _PullType.gold
      ? const [Color(0xFFFBBF24), Color(0xFFD97706), Color(0xFF92400E)]
      : const [Color(0xFFCBD5E1), Color(0xFF94A3B8), Color(0xFF475569)];

  List<Color> get _bgGradient => widget.type == _PullType.gold
      ? const [Color(0xFF2A1E08), Color(0xFF0D1810)]
      : const [Color(0xFF1A2230), Color(0xFF0D1810)];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _bgGradient,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _glowColor.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // ── Animated card area ─────────────────────────────────────────
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Animated radial glow
                AnimatedBuilder(
                  animation: _glow,
                  builder: (context, _) => Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(18)),
                      gradient: RadialGradient(
                        radius: 0.85,
                        colors: [
                          _glowColor.withValues(
                              alpha: 0.18 + 0.18 * _glow.value),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Floating card
                AnimatedBuilder(
                  animation: _float,
                  builder: (context, _) => Transform.translate(
                    offset: Offset(0, _float.value),
                    child: _MiniCard(
                      colors: _cardColors,
                      glowColor: _glowColor,
                      glowIntensity: _glow.value,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info + buy ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title — single line, no wrapping
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.5,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 5),
                // Rarity range chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: _glowColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.rarityRange,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: _glowColor,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Draw button — full width, centered
                SizedBox(
                  width: double.infinity,
                  child: _DrawButton(
                    color: _glowColor,
                    label: 'DRAW',
                    onTap: () => _openDrawReveal(
                      context,
                      widget.type == _PullType.gold
                          ? _DrawType.gold
                          : _DrawType.silver,
                    ),
                  ),
                ),
                const SizedBox(height: 7),

                // Cost label — centered below button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.costIcon, size: 11, color: widget.costColor),
                    const SizedBox(width: 4),
                    Text(
                      widget.costLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: widget.costColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Event Card item ──────────────────────────────────────────────────────────

class _EventCardItem extends StatefulWidget {
  const _EventCardItem();

  @override
  State<_EventCardItem> createState() => _EventCardItemState();
}

class _EventCardItemState extends State<_EventCardItem>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _glowCtrl;
  late final Animation<double> _float;
  late final Animation<double> _shimmer;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();
    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _float = Tween<double>(begin: -8.0, end: 8.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _shimmer = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.linear));
    _glow = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    _particleCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF200A3A), Color(0xFF18073A), Color(0xFF0D1810)],
          stops: [0.0, 0.60, 1.0],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _event.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _event.withValues(alpha: 0.30),
            blurRadius: 28,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            // ── Animated card area ──────────────────────────────────────
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Particle background
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: _particleCtrl,
                      builder: (context, _) => CustomPaint(
                        painter: _EventParticlesPainter(
                            _particleCtrl.value, _event),
                      ),
                    ),
                  ),
                  // Pulsing radial glow
                  AnimatedBuilder(
                    animation: _glow,
                    builder: (context, _) => Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          radius: 0.70,
                          colors: [
                            _event.withValues(
                                alpha: 0.22 + 0.18 * _glow.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Floating card with shimmer
                  AnimatedBuilder(
                    animation:
                        Listenable.merge([_floatCtrl, _shimmerCtrl, _glowCtrl]),
                    builder: (context, _) => Transform.translate(
                      offset: Offset(0, _float.value),
                      child: _MiniCard(
                        colors: const [
                          Color(0xFFE9D5FF),
                          Color(0xFFA855F7),
                          Color(0xFF5B21B6),
                        ],
                        glowColor: _event,
                        glowIntensity: 0.5 + 0.5 * _glow.value,
                        shimmerProgress: _shimmer.value,
                        size: 90,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info + buy ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _event.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _event.withValues(alpha: 0.50)),
                    ),
                    child: const Text(
                      'LIMITED EVENT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _event,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ANIME EVENT DRAW',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Japanese Anime • Guaranteed Rare+',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _event.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Rare – Unique',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: _event,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // DRAW button — full width
                  SizedBox(
                    width: double.infinity,
                    child: _DrawButton(
                      color: _event,
                      label: 'DRAW',
                      onTap: () =>
                          _openDrawReveal(context, _DrawType.event),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Cost label — centered
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 11, color: _event),
                      const SizedBox(width: 5),
                      Text(
                        '1 Event Book',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: _event.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Mini Card visual ─────────────────────────────────────────────────────────

class _MiniCard extends StatelessWidget {
  const _MiniCard({
    required this.colors,
    required this.glowColor,
    required this.glowIntensity,
    this.shimmerProgress,
    this.size = 64,
  });

  final List<Color> colors;
  final Color glowColor;
  final double glowIntensity;
  final double? shimmerProgress;
  final double size;

  @override
  Widget build(BuildContext context) {
    final w = size;
    final h = size * (90 / 64);
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.30 + 0.28 * glowIntensity),
            blurRadius: 18 + 10 * glowIntensity,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: glowColor.withValues(alpha: 0.12 + 0.10 * glowIntensity),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Stack(
          children: [
            // Dot pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _MiniCardDotPainter(glowColor),
              ),
            ),
            // L-corner ornaments
            _miniCorner(top: 4, left: 4, angle: 0),
            _miniCorner(top: 4, right: 4, angle: math.pi / 2),
            _miniCorner(bottom: 4, left: 4, angle: -math.pi / 2),
            _miniCorner(bottom: 4, right: 4, angle: math.pi),
            // Center icon
            Center(
              child: Icon(
                Icons.menu_book_rounded,
                size: 22,
                color: Colors.white.withValues(alpha: 0.70),
              ),
            ),
            // Shimmer sweep (event only)
            if (shimmerProgress != null)
              _ShimmerSweep(progress: shimmerProgress!),
          ],
        ),
      ),
    );
  }

  Widget _miniCorner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double angle,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: SizedBox(
          width: 8,
          height: 8,
          child: CustomPaint(painter: _MiniCornerPainter(glowColor)),
        ),
      ),
    );
  }
}

// ─── Shimmer sweep overlay ────────────────────────────────────────────────────

class _ShimmerSweep extends StatelessWidget {
  const _ShimmerSweep({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder lets us adapt to actual card width at runtime
    return LayoutBuilder(builder: (context, constraints) {
      final cardW  = constraints.maxWidth;
      const stripeW = 22.0;
      final x = progress * (cardW + stripeW * 2) - stripeW;
      return _buildSweep(x, stripeW);
    });
  }

  Widget _buildSweep(double x, double stripeW) {

    return Positioned.fill(
      child: Transform.translate(
        offset: Offset(x, 0),
        child: Container(
          width: stripeW,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(alpha: 0.0),
                Colors.white.withValues(alpha: 0.35),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ─── Draw button ──────────────────────────────────────────────────────────────

class _DrawButton extends StatelessWidget {
  const _DrawButton({required this.color, required this.label, this.onTap});

  final Color color;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.75)],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.38),
              blurRadius: 12,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Painters
// ─────────────────────────────────────────────────────────────────────────────

class _MiniCardDotPainter extends CustomPainter {
  const _MiniCardDotPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    const s = 8.0;
    for (double x = s; x < size.width; x += s) {
      for (double y = s; y < size.height; y += s) {
        canvas.drawCircle(Offset(x, y), 0.9, p);
      }
    }
  }

  @override
  bool shouldRepaint(_MiniCardDotPainter old) => false;
}

class _MiniCornerPainter extends CustomPainter {
  const _MiniCornerPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.50)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, size.height), Offset.zero, p);
    canvas.drawLine(Offset.zero, Offset(size.width, 0), p);
  }

  @override
  bool shouldRepaint(_MiniCornerPainter old) => false;
}

class _EventParticlesPainter extends CustomPainter {
  const _EventParticlesPainter(this.progress, this.color);

  final double progress;
  final Color color;

  static final _rng = math.Random(42);
  static final List<_Particle> _particles = List.generate(
    22,
    (i) => _Particle(
      x: _rng.nextDouble(),
      y: _rng.nextDouble(),
      size: 1.5 + _rng.nextDouble() * 2.5,
      speed: 0.15 + _rng.nextDouble() * 0.35,
      phase: _rng.nextDouble(),
    ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in _particles) {
      final t = (progress * p.speed + p.phase) % 1.0;
      // Vertical drift upward, wrap around
      final y = (p.y - t * 0.6) % 1.0;
      final alpha = t < 0.2
          ? t / 0.2 * 0.55
          : t > 0.8
              ? (1 - t) / 0.2 * 0.55
              : 0.55;

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      // Diamond / sparkle shape
      final cx = p.x * size.width;
      final cy = y * size.height;
      final r = p.size;

      final path = Path()
        ..moveTo(cx, cy - r)
        ..lineTo(cx + r * 0.45, cy)
        ..lineTo(cx, cy + r)
        ..lineTo(cx - r * 0.45, cy)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_EventParticlesPainter old) =>
      old.progress != progress;
}

class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
  });

  final double x, y, size, speed, phase;
}

// ─── Draw Reveal Dialog ───────────────────────────────────────────────────────

class _DrawRevealDialog extends StatefulWidget {
  const _DrawRevealDialog({
    required this.drawType,
    required this.resultCard,
  });

  final _DrawType drawType;
  final KnowledgeCardModel resultCard;

  @override
  State<_DrawRevealDialog> createState() => _DrawRevealDialogState();
}

class _DrawRevealDialogState extends State<_DrawRevealDialog>
    with TickerProviderStateMixin {
  // Master controller: 3200ms — covers the full book→card reveal sequence
  late final AnimationController _master;
  // Float controller: repeating — starts after master completes
  late final AnimationController _floatCtrl;

  // ── Book shake (X-axis oscillation) ────────────────────────────────────────
  late final Animation<double> _bookShakeX;

  // ── Glow pulse behind book ──────────────────────────────────────────────────
  late final Animation<double> _glowOpacity;

  // ── White flash transition ──────────────────────────────────────────────────
  late final Animation<double> _flashOpacity;

  // ── Card entrance ──────────────────────────────────────────────────────────
  late final Animation<double> _cardScale;
  late final Animation<double> _cardRotY;
  late final Animation<double> _cardOpacity;

  // ── Labels ──────────────────────────────────────────────────────────────────
  late final Animation<double> _labelOpacity;
  late final Animation<double> _hintOpacity;

  // ── Float (post-reveal) ─────────────────────────────────────────────────────
  late final Animation<double> _floatY;

  bool _canDismiss = false;

  Color get _accentColor {
    switch (widget.drawType) {
      case _DrawType.silver: return _silver;
      case _DrawType.gold:   return _gold;
      case _DrawType.event:  return _event;
    }
  }

  IconData get _bookIcon {
    switch (widget.drawType) {
      case _DrawType.silver: return Icons.menu_book_rounded;
      case _DrawType.gold:   return Icons.auto_stories_rounded;
      case _DrawType.event:  return Icons.star_rounded;
    }
  }

  @override
  void initState() {
    super.initState();

    _master = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // Book shake: TweenSequence oscillation — interval 0.00–0.28
    _bookShakeX = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12, end: 12), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12, end: -10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -7), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -7, end: 7), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 7, end: 0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _master,
      curve: const Interval(0.00, 0.28),
    ));

    // Glow opacity: 0 → 1 → 0 — interval 0.03–0.50
    _glowOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _master,
      curve: const Interval(0.03, 0.50),
    ));

    // Flash: 0 → 1 → 0 — interval 0.30–0.46
    _flashOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _master,
      curve: const Interval(0.30, 0.46),
    ));

    // Card scale: 0.03 → 1.0, easeOutQuart — interval 0.44–0.88
    _cardScale = Tween<double>(begin: 0.03, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.44, 0.88, curve: Curves.easeOutQuart),
      ),
    );

    // Card rotation Y: π*4.5 → 0, easeOutCubic — interval 0.44–0.85
    _cardRotY = Tween<double>(begin: math.pi * 4.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.44, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    // Card opacity: 0 → 1 — interval 0.44–0.54
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.44, 0.54),
      ),
    );

    // Label opacity — interval 0.85–0.94
    _labelOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.85, 0.94, curve: Curves.easeOut),
      ),
    );

    // Hint opacity — interval 0.95–1.00
    _hintOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _master,
        curve: const Interval(0.95, 1.00, curve: Curves.easeOut),
      ),
    );

    // Float Y: -8 → 8, repeating
    _floatY = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    // Start master, then begin float loop when done
    _master.forward().then((_) {
      if (mounted) {
        setState(() => _canDismiss = true);
        _floatCtrl.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _master.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_canDismiss) Navigator.of(context).pop();
      },
      child: Material(
        color: Colors.black.withValues(alpha: 0.88),
        child: AnimatedBuilder(
          animation: Listenable.merge([_master, _floatCtrl]),
          builder: (context, _) {
            final masterVal = _master.value;
            final showBook  = masterVal < 0.46;
            final showCard  = masterVal >= 0.44;

            return Stack(
              alignment: Alignment.center,
              children: [
                // ── Radial glow background ──────────────────────────────────
                if (showBook)
                  Opacity(
                    opacity: _glowOpacity.value.clamp(0.0, 1.0),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            _accentColor.withValues(alpha: 0.45),
                            _accentColor.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Book phase ────────────────────────────────────────────
                if (showBook)
                  Transform.translate(
                    offset: Offset(_bookShakeX.value, 0),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentColor.withValues(alpha: 0.12),
                        border: Border.all(
                          color: _accentColor.withValues(alpha: 0.40),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withValues(
                              alpha: _glowOpacity.value * 0.6,
                            ),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        _bookIcon,
                        size: 56,
                        color: _accentColor,
                        shadows: [
                          Shadow(
                            color: _accentColor.withValues(alpha: 0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Card phase ────────────────────────────────────────────
                if (showCard)
                  Opacity(
                    opacity: _cardOpacity.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(
                        0,
                        _canDismiss ? _floatY.value : 0,
                      ),
                      child: AbsorbPointer(
                        absorbing: !_canDismiss,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.0012)
                            ..rotateY(_cardRotY.value)
                            ..scaleByDouble(
                                _cardScale.value,
                                _cardScale.value,
                                _cardScale.value,
                                1.0,
                              ),
                          child: SizedBox(
                            width: 180,
                            height: 180 / 0.68,
                            child: KnowledgeCardWidget(
                              card: widget.resultCard,
                              key: ValueKey(widget.resultCard.id),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Labels (below card) ───────────────────────────────────
                if (showCard)
                  Positioned(
                    bottom: 80,
                    left: 32,
                    right: 32,
                    child: Opacity(
                      opacity: _labelOpacity.value.clamp(0.0, 1.0),
                      child: Column(
                        children: [
                          Text(
                            widget.resultCard.rarity.label.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: widget.resultCard.rarity.color,
                              letterSpacing: 2.0,
                              shadows: [
                                Shadow(
                                  color: widget.resultCard.rarity.color
                                      .withValues(alpha: 0.7),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'NEW CARD OBTAINED',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Tap to continue hint ──────────────────────────────────
                Positioned(
                  bottom: 40,
                  child: Opacity(
                    opacity: _hintOpacity.value.clamp(0.0, 1.0),
                    child: const Text(
                      'TAP TO CONTINUE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                // ── White flash overlay ───────────────────────────────────
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _flashOpacity.value.clamp(0.0, 1.0),
                      child: const ColoredBox(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

