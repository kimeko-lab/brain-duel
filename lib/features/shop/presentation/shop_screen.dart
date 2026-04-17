import 'dart:math' as math;

import 'package:flutter/material.dart';

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

// ─── Pull type ────────────────────────────────────────────────────────────────

enum _PullType { silver, gold }

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
                  child: _DrawButton(color: _glowColor, label: 'DRAW'),
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
  late final Animation<double> _float;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat();

    _float = Tween<double>(begin: -7.0, end: 7.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));
    _shimmer = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF200A3A), Color(0xFF2E1065), Color(0xFF0D1810)],
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _event.withValues(alpha: 0.50),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _event.withValues(alpha: 0.25),
            blurRadius: 22,
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // ── Particle background ──────────────────────────────────────
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleCtrl,
                builder: (context, _) => CustomPaint(
                  painter:
                      _EventParticlesPainter(_particleCtrl.value, _event),
                ),
              ),
            ),

            // ── Content row ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  // Animated event card (float + shimmer)
                  SizedBox(
                    width: 100,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: Listenable.merge(
                            [_floatCtrl, _shimmerCtrl]),
                        builder: (context, _) => Transform.translate(
                          offset: Offset(0, _float.value),
                          child: _MiniCard(
                            colors: const [
                              Color(0xFFD8B4FE),
                              Color(0xFFA855F7),
                              Color(0xFF6D28D9),
                            ],
                            glowColor: _event,
                            glowIntensity: 0.7,
                            shimmerProgress: _shimmer.value,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // Right: info + button
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: _event.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: _event.withValues(alpha: 0.45)),
                          ),
                          child: const Text(
                            'LIMITED EVENT',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              color: _event,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Anime Event\nCard Draw',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Japanese Anime • Guaranteed Rare+',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome_rounded,
                                size: 12, color: _event),
                            const SizedBox(width: 4),
                            const Text(
                              '1 Event Book',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _event,
                              ),
                            ),
                            const Spacer(),
                            _DrawButton(color: _event, label: 'DRAW'),
                          ],
                        ),
                      ],
                    ),
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
  });

  final List<Color> colors;
  final Color glowColor;
  final double glowIntensity;
  final double? shimmerProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 90,
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
    // Map progress 0→1→2 → stripe moves from -width to 2*width
    const cardW = 64.0;
    const stripeW = 22.0;
    final x = progress * (cardW + stripeW * 2) - stripeW;

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
  const _DrawButton({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
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
