# Arcane Library Redesign Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace all animated backgrounds with a static `ArcaneLibraryBackground`; upgrade Home screen and Daily Classic typography + accents; eliminate all AnimationController-based background lag.

**Architecture:** A new `ArcaneLibraryBackground` (`StatelessWidget` + static `CustomPainter`) replaces `LibraryBackground` and `SkyBackground` across all screens. The shell provides the background for tab screens; standalone game screens keep their own wrapper. Home screen gets gradient title, teal accents, and subtitle update. Daily Classic result screen gets gradient title. Survival/Rush get background swap only.

**Tech Stack:** Flutter/Dart, AppColors token system, CustomPainter, ShaderMask, RepaintBoundary

---

## File Map

| Action | File | Responsibility |
|---|---|---|
| Create | `lib/core/widgets/background/arcane_library_background.dart` | New static background widget |
| Delete | `lib/core/widgets/background/library_background.dart` | Old warm library (animated) |
| Delete | `lib/core/widgets/background/sky_background.dart` | Old sky background (animated) |
| Delete | `lib/core/widgets/background/arcane_background.dart` | Old arcane background (animated) |
| Modify | `lib/core/widgets/app_shell.dart` | Swap LibraryBackground → ArcaneLibraryBackground |
| Modify | `lib/features/home/presentation/home_screen.dart` | Remove wrapper + visual upgrade |
| Modify | `lib/features/daily/presentation/category_select_screen.dart` | Swap background + gradient title |
| Modify | `lib/features/daily/presentation/widgets/category_grid_item.dart` | Icon container → gradient |
| Modify | `lib/features/daily/presentation/daily_classic_game_screen.dart` | Swap background |
| Modify | `lib/features/daily/presentation/widgets/answer_option_tile.dart` | Default border → teal |
| Modify | `lib/features/daily/presentation/daily_classic_result_screen.dart` | Swap background + gradient title + Home button border |
| Modify | `lib/features/survival/presentation/survival_game_screen.dart` | Background swap only |
| Modify | `lib/features/survival/presentation/survival_result_screen.dart` | Background swap only |
| Modify | `lib/features/rush/presentation/rush_game_screen.dart` | Background swap only |
| Modify | `lib/features/rush/presentation/rush_result_screen.dart` | Background swap only |

---

## Task 1: Create ArcaneLibraryBackground

**Files:**
- Create: `lib/core/widgets/background/arcane_library_background.dart`

- [ ] **Step 1: Create the file with 5-layer static CustomPainter**

```dart
import 'package:flutter/material.dart';

/// Static, zero-animation scholarly library background.
/// Deep purple tones + teal glow orbs + bookshelf silhouettes.
///
/// Uses [RepaintBoundary] around the [CustomPaint] so screen content
/// repaints never trigger a background repaint.
class ArcaneLibraryBackground extends StatelessWidget {
  const ArcaneLibraryBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RepaintBoundary(
          child: CustomPaint(
            painter: _ArcaneLibraryPainter(),
            child: const SizedBox.expand(),
          ),
        ),
        child,
      ],
    );
  }
}

class _ArcaneLibraryPainter extends CustomPainter {
  const _ArcaneLibraryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawGlowOrbs(canvas, size);
    _drawDustParticles(canvas, size);
    _drawBookshelves(canvas, size);
    _drawVignette(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0d0a1e), Color(0xFF160e2e), Color(0xFF0a0618)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);
    canvas.drawRect(rect, paint);
  }

  void _drawGlowOrbs(Canvas canvas, Size size) {
    final paint = Paint();

    // Left purple orb
    final leftCenter = Offset(size.width * 0.18, size.height * 0.18);
    final leftR = size.width * 0.38;
    paint.shader = RadialGradient(
      colors: [const Color(0xFF8a50dc).withValues(alpha: 0.22), Colors.transparent],
    ).createShader(Rect.fromCircle(center: leftCenter, radius: leftR));
    canvas.drawCircle(leftCenter, leftR, paint);

    // Right teal orb
    final rightCenter = Offset(size.width * 0.84, size.height * 0.22);
    final rightR = size.width * 0.32;
    paint.shader = RadialGradient(
      colors: [const Color(0xFF2dd2be).withValues(alpha: 0.18), Colors.transparent],
    ).createShader(Rect.fromCircle(center: rightCenter, radius: rightR));
    canvas.drawCircle(rightCenter, rightR, paint);

    // Subtle center orb
    final midCenter = Offset(size.width * 0.50, size.height * 0.38);
    final midR = size.width * 0.42;
    paint.shader = RadialGradient(
      colors: [const Color(0xFF8a50dc).withValues(alpha: 0.10), Colors.transparent],
    ).createShader(Rect.fromCircle(center: midCenter, radius: midR));
    canvas.drawCircle(midCenter, midR, paint);
  }

  void _drawDustParticles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    // (xFraction, yFraction, radius, isPurple)
    const dots = [
      (0.15, 0.07, 1.5, true),  (0.34, 0.11, 1.0, false),
      (0.60, 0.05, 2.0, true),  (0.78, 0.13, 1.5, false),
      (0.90, 0.08, 1.0, true),  (0.25, 0.19, 2.5, false),
      (0.50, 0.17, 1.0, true),  (0.70, 0.22, 1.5, false),
      (0.08, 0.29, 2.0, true),  (0.44, 0.27, 1.0, false),
      (0.85, 0.31, 2.5, true),  (0.22, 0.34, 1.5, false),
    ];
    for (final d in dots) {
      paint.color = (d.$4
          ? const Color(0xFF8a50dc)
          : const Color(0xFF2dd2be))
          .withValues(alpha: 0.45);
      canvas.drawCircle(Offset(size.width * d.$1, size.height * d.$2), d.$3, paint);
    }
  }

  void _drawBookshelves(Canvas canvas, Size size) {
    _drawShelfRow(canvas, size,
      colors: const [Color(0xFF1e0830), Color(0xFF240e38), Color(0xFF1a0628)],
      baseY: size.height * 0.72, maxH: size.height * 0.09);
    _drawShelfRow(canvas, size,
      colors: const [Color(0xFF2a1040), Color(0xFF321658), Color(0xFF241040)],
      baseY: size.height * 0.80, maxH: size.height * 0.11);
    _drawShelfRow(canvas, size,
      colors: const [Color(0xFF3c1660), Color(0xFF4a1a78), Color(0xFF34145a)],
      baseY: size.height * 0.89, maxH: size.height * 0.13);
  }

  void _drawShelfRow(Canvas canvas, Size size, {
    required List<Color> colors,
    required double baseY,
    required double maxH,
  }) {
    const ws = [14.0, 10.0, 16.0, 12.0, 18.0, 11.0, 15.0, 13.0, 17.0, 12.0];
    const hs = [0.85, 0.65, 0.95, 0.55, 0.80, 0.70, 0.90, 0.60, 0.75, 0.72];

    final paint = Paint()..style = PaintingStyle.fill;
    var x = 0.0;
    var i = 0;
    while (x < size.width) {
      final idx = i % ws.length;
      paint.color = colors[i % colors.length];
      final h = maxH * hs[idx];
      canvas.drawRect(Rect.fromLTWH(x + 0.5, baseY - h, ws[idx] - 1, h), paint);
      x += ws[idx] + 1;
      i++;
    }
    // Shelf baseline
    paint.color = colors[0];
    canvas.drawRect(Rect.fromLTWH(0, baseY, size.width, 2), paint);
  }

  void _drawVignette(Canvas canvas, Size size) {
    final vignetteRect = Rect.fromLTWH(0, size.height * 0.78, size.width, size.height * 0.22);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.transparent, Color(0xFF08040f)],
      ).createShader(vignetteRect);
    canvas.drawRect(vignetteRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

- [ ] **Step 2: Run analyze**

```bash
cd "C:/Users/ariep/Superapp/brain-duel" && flutter analyze --no-fatal-infos 2>&1 | tail -5
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
cd "C:/Users/ariep/Superapp/brain-duel"
git add lib/core/widgets/background/arcane_library_background.dart
git commit -m "feat: add static ArcaneLibraryBackground widget"
```

---

## Task 2: Update AppShell

**Files:**
- Modify: `lib/core/widgets/app_shell.dart`

- [ ] **Step 1: Swap import and widget**

In `lib/core/widgets/app_shell.dart`:

Replace line 4:
```dart
import 'background/library_background.dart';
```
With:
```dart
import 'background/arcane_library_background.dart';
```

Replace in `build()` method (line 42):
```dart
return LibraryBackground(
```
With:
```dart
return ArcaneLibraryBackground(
```

- [ ] **Step 2: Run analyze**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -5
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/core/widgets/app_shell.dart
git commit -m "feat: shell uses ArcaneLibraryBackground"
```

---

## Task 3: Upgrade HomeScreen

**Files:**
- Modify: `lib/features/home/presentation/home_screen.dart`

The goal: remove `LibraryBackground` wrapper (shell now provides it), upgrade 5 visual areas.

- [ ] **Step 1: Remove LibraryBackground import and wrapper**

Remove line 10:
```dart
import '../../../core/widgets/background/library_background.dart';
```

In `build()`, replace:
```dart
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: LibraryBackground(
        child: SafeArea(
```
With:
```dart
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
```
And remove the matching closing `)` of `LibraryBackground`. The `Scaffold` body is now just `SafeArea(...)` directly.

- [ ] **Step 2: Upgrade title + subtitle (in `_buildHeader`)**

Replace the title+subtitle block:
```dart
            Text(
              'Brain Duel',
              style: AppTypography.displaySmall.copyWith(
                shadows: [
                  Shadow(
                    color: AppColors.rarityLegendary.withValues(alpha: 0.45),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Test your mind. Duel the world.',
              style: AppTypography.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
```
With:
```dart
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFe8d8ff), AppColors.primary],
              ).createShader(bounds),
              blendMode: BlendMode.srcIn,
              child: const Text(
                'Brain Duel',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Where scholars become champions.',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ).copyWith(color: AppColors.primary.withValues(alpha: 0.7)),
            ),
```

- [ ] **Step 3: Upgrade avatar border (in `_AvatarWidget`)**

Replace:
```dart
            border: Border.all(
              color: AppColors.rarityLegendary.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.rarityLegendary.withValues(alpha: 0.2),
                blurRadius: 14,
                spreadRadius: -2,
              ),
            ],
```
With:
```dart
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 14,
                spreadRadius: -2,
              ),
            ],
```

- [ ] **Step 4: Upgrade currency badges (in `_CurrencyBadge`)**

The Silver badge currently uses `accent: AppColors.textSecondary`. Change the call at the call site in `_buildHeader()`:
```dart
        _CurrencyBadge(
          icon: Icons.menu_book_rounded,
          amount: 240,
          label: 'Silver',
          accent: AppColors.textSecondary,
        ),
```
Change to:
```dart
        _CurrencyBadge(
          icon: Icons.menu_book_rounded,
          amount: 240,
          label: 'Silver',
          accent: AppColors.primary,
        ),
```

- [ ] **Step 5: Upgrade "Game Modes" section label (in `_buildModesSection`)**

Replace:
```dart
          child: Text(
            'Game Modes',
            style: AppTypography.headlineLarge.copyWith(
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
          ),
```
With:
```dart
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Game Modes',
                style: TextStyle(
                  fontFamily: 'Fraunces',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFc8b8f0),
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 24, height: 2, color: AppColors.primary),
            ],
          ),
```

- [ ] **Step 6: Upgrade Classic card border + glow (in `_ModeCard` call site)**

Change the Classic `_ModeCard(...)` constructor call:
```dart
        _ModeCard(
          title: 'Classic',
          subtitle: 'Daily · Survival · Rush',
          icon: Icons.auto_stories_rounded,
          accent: AppColors.primary,
          isPrimary: true,
          delay: 400,
          onTap: () => _showClassicSheet(context),
        ),
```
No change needed at call site — `accent` is already `AppColors.primary`. The border alpha needs fixing inside `_ModeCard._build()`:

In `_ModeCard.build()`, replace:
```dart
      borderColor: accent.withValues(alpha: isPrimary ? 0.7 : 0.4),
      glowColor: isPrimary ? accent.withValues(alpha: 0.35) : null,
      borderWidth: isPrimary ? 2 : 1,
```
With:
```dart
      borderColor: accent.withValues(alpha: isPrimary ? 1.0 : 0.4),
      glowColor: isPrimary ? accent.withValues(alpha: 0.3) : null,
      borderWidth: isPrimary ? 1.5 : 1.0,
```

- [ ] **Step 7: Upgrade Classic card icon container (in `_ModeCard.build()`)**

Replace the icon container `decoration`:
```dart
            decoration: BoxDecoration(
              color: accent.withValues(alpha: comingSoon ? 0.08 : 0.18),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: accent.withValues(alpha: comingSoon ? 0.2 : 0.5),
                width: 1.5,
              ),
              boxShadow: [
                if (!comingSoon)
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: -4,
                  ),
              ],
            ),
```
With:
```dart
            decoration: BoxDecoration(
              gradient: comingSoon ? null : AppColors.primaryGradient,
              color: comingSoon ? accent.withValues(alpha: 0.08) : null,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: comingSoon
                  ? Border.all(color: accent.withValues(alpha: 0.2), width: 1.5)
                  : null,
              boxShadow: [
                if (!comingSoon)
                  BoxShadow(
                    color: accent.withValues(alpha: 0.3),
                    blurRadius: 16,
                    spreadRadius: -4,
                  ),
              ],
            ),
```

- [ ] **Step 8: Upgrade Classic card title + subtitle text styles (in `_ModeCard.build()`)**

Replace the title Text:
```dart
                Text(
                  title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: comingSoon
                        ? AppColors.textTertiary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: comingSoon
                        ? AppColors.textDisabled
                        : AppColors.textPrimary.withValues(alpha: 0.75),
                  ),
                ),
```
With:
```dart
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Fraunces',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: comingSoon ? AppColors.textTertiary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: comingSoon
                        ? AppColors.textDisabled
                        : AppColors.primary.withValues(alpha: 0.7),
                  ),
                ),
```

- [ ] **Step 9: Upgrade Versus card — Opacity wrapper + badge colors**

At call site, wrap the Versus `_ModeCard` in `Opacity`:
```dart
        _ModeCard(
          title: 'Versus',
          ...
          comingSoon: true,
        ),
```
With:
```dart
        Opacity(
          opacity: 0.35,
          child: _ModeCard(
            title: 'Versus',
            subtitle: 'Coming Soon',
            icon: Icons.sports_kabaddi_rounded,
            accent: AppColors.rarityUnique,
            isPrimary: false,
            delay: 500,
            comingSoon: true,
          ),
        ),
```

Inside `_ModeCard.build()`, replace the SOON badge decoration:
```dart
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.rarityLegendary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                      border: Border.all(
                        color: AppColors.rarityLegendary.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'SOON',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.rarityLegendary.withValues(alpha: 0.7),
                        letterSpacing: 1,
                      ),
                    ),
                  )
```
With:
```dart
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryDark,
                        width: 1,
                      ),
                    ),
                    child: const Text(
                      'SOON',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                  )
```

- [ ] **Step 10: Run analyze**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -5
```
Expected: `No issues found!`

- [ ] **Step 11: Run tests**

```bash
flutter test 2>&1 | tail -5
```
Expected: `+103: All tests passed!`

- [ ] **Step 12: Commit**

```bash
git add lib/features/home/presentation/home_screen.dart
git commit -m "feat: upgrade Home screen to Arcane Library theme"
```

---

## Task 4: Update Daily Classic — Category Select

**Files:**
- Modify: `lib/features/daily/presentation/category_select_screen.dart`
- Modify: `lib/features/daily/presentation/widgets/category_grid_item.dart`

- [ ] **Step 1: Swap background import in category_select_screen.dart**

Replace:
```dart
import '../../../core/widgets/background/sky_background.dart';
```
With:
```dart
import '../../../core/widgets/background/arcane_library_background.dart';
```

Replace `SkyBackground(` with `ArcaneLibraryBackground(`.

- [ ] **Step 2: Wrap title in ShaderMask in category_select_screen.dart**

Replace:
```dart
                Text(
                  'Choose a category',
                  style: AppTypography.headlineLarge,
                ),
```
With:
```dart
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFe8d8ff), AppColors.primary],
                  ).createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: const Text(
                    'Choose a category',
                    style: TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
```

Add import at top of `category_select_screen.dart`:
```dart
import '../../../core/theme/app_colors.dart';
```

- [ ] **Step 3: Add gradient to category icon container in category_grid_item.dart**

In `_GlassTile.build()`, the icon is rendered as:
```dart
              Icon(widget.icon, size: 36, color: AppColors.primary),
```

Wrap in a gradient container — replace that `Icon(...)` line with:
```dart
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, size: 28, color: AppColors.mountainNear),
              ),
```

- [ ] **Step 4: Run analyze**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -5
```
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/daily/presentation/category_select_screen.dart \
        lib/features/daily/presentation/widgets/category_grid_item.dart
git commit -m "feat: Daily Classic category select — Arcane Library theme"
```

---

## Task 5: Update Daily Classic — Game Screen + AnswerOptionTile

**Files:**
- Modify: `lib/features/daily/presentation/daily_classic_game_screen.dart`
- Modify: `lib/features/daily/presentation/widgets/answer_option_tile.dart`

- [ ] **Step 1: Swap background in daily_classic_game_screen.dart**

Replace:
```dart
import '../../../core/widgets/background/sky_background.dart';
```
With:
```dart
import '../../../core/widgets/background/arcane_library_background.dart';
```

Replace `SkyBackground(` with `ArcaneLibraryBackground(`.

- [ ] **Step 2: Update default tile border in answer_option_tile.dart**

In `AnswerOptionTile._borderColor` getter, replace:
```dart
    if (!_isFeedbackPhase) {
      return Colors.white.withValues(alpha: 0.15);
    }
```
With:
```dart
    if (!_isFeedbackPhase) {
      return AppColors.primary.withValues(alpha: 0.3);
    }
```

- [ ] **Step 3: Run analyze**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -5
```
Expected: `No issues found!`

- [ ] **Step 4: Run tests**

```bash
flutter test 2>&1 | tail -5
```
Expected: `+103: All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/daily/presentation/daily_classic_game_screen.dart \
        lib/features/daily/presentation/widgets/answer_option_tile.dart
git commit -m "feat: Daily Classic game — Arcane Library background + teal tile borders"
```

---

## Task 6: Update Daily Classic — Result Screen

**Files:**
- Modify: `lib/features/daily/presentation/daily_classic_result_screen.dart`

- [ ] **Step 1: Swap background import**

Replace:
```dart
import '../../../core/widgets/background/sky_background.dart';
```
With:
```dart
import '../../../core/widgets/background/arcane_library_background.dart';
```

Replace `SkyBackground(` with `ArcaneLibraryBackground(`.

- [ ] **Step 2: Apply ShaderMask to "Daily Classic" title**

Replace:
```dart
                    Text(
                      'Daily Classic',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
```
With:
```dart
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFe8d8ff), AppColors.primary],
                      ).createShader(bounds),
                      blendMode: BlendMode.srcIn,
                      child: Text(
                        'Daily Classic',
                        textAlign: TextAlign.center,
                        style: AppTypography.displayMedium.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
```

- [ ] **Step 3: Update "Home" button border in `_buildButton`**

In `_buildButton`, when `primary == false`, replace:
```dart
      borderColor: AppColors.borderStrong,
```
With:
```dart
      borderColor: AppColors.primary.withValues(alpha: 0.6),
```

- [ ] **Step 4: Run analyze + tests**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -5 && flutter test 2>&1 | tail -5
```
Expected: `No issues found!` and `+103: All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/daily/presentation/daily_classic_result_screen.dart
git commit -m "feat: Daily Classic result — Arcane Library background + gradient title"
```

---

## Task 7: Update Survival & Rush (Background Swap Only)

**Files:**
- Modify: `lib/features/survival/presentation/survival_game_screen.dart`
- Modify: `lib/features/survival/presentation/survival_result_screen.dart`
- Modify: `lib/features/rush/presentation/rush_game_screen.dart`
- Modify: `lib/features/rush/presentation/rush_result_screen.dart`

All 4 files: same 2-line change each (import swap + widget name swap). No color changes needed — these screens already use `AppColors.primary` and `AppColors.primaryGradient`.

- [ ] **Step 1: Update all 4 files**

In each file, replace:
```dart
import '../../../core/widgets/background/sky_background.dart';
```
With:
```dart
import '../../../core/widgets/background/arcane_library_background.dart';
```

And replace `SkyBackground(` with `ArcaneLibraryBackground(`.

Files to edit:
- `lib/features/survival/presentation/survival_game_screen.dart` (line 8 + line 83)
- `lib/features/survival/presentation/survival_result_screen.dart` (line 10 + line 26)
- `lib/features/rush/presentation/rush_game_screen.dart` (line 8 + line 77)
- `lib/features/rush/presentation/rush_result_screen.dart` (line 10 + line 27)

- [ ] **Step 2: Run analyze**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -5
```
Expected: `No issues found!`

- [ ] **Step 3: Commit**

```bash
git add lib/features/survival/presentation/survival_game_screen.dart \
        lib/features/survival/presentation/survival_result_screen.dart \
        lib/features/rush/presentation/rush_game_screen.dart \
        lib/features/rush/presentation/rush_result_screen.dart
git commit -m "feat: Survival + Rush — swap to ArcaneLibraryBackground"
```

---

## Task 8: Delete Old Backgrounds + Final Verification + Deploy

**Files:**
- Delete: `lib/core/widgets/background/library_background.dart`
- Delete: `lib/core/widgets/background/sky_background.dart`
- Delete: `lib/core/widgets/background/arcane_background.dart`

- [ ] **Step 1: Delete the 3 old background files**

```bash
cd "C:/Users/ariep/Superapp/brain-duel"
rm lib/core/widgets/background/library_background.dart
rm lib/core/widgets/background/sky_background.dart
rm lib/core/widgets/background/arcane_background.dart
```

- [ ] **Step 2: Run analyze — must be clean**

```bash
flutter analyze --no-fatal-infos 2>&1 | tail -10
```
Expected: `No issues found!`

If there are any dangling import errors: find and fix them. This should not happen if Tasks 1–7 were done correctly.

- [ ] **Step 3: Run all tests**

```bash
flutter test 2>&1 | tail -5
```
Expected: `+103: All tests passed!`

- [ ] **Step 4: Commit deletions**

```bash
git add -A
git commit -m "chore: delete animated backgrounds (library, sky, arcane) — replaced by ArcaneLibraryBackground"
```

- [ ] **Step 5: Build release APK**

```bash
flutter build apk --release 2>&1 | tail -5
```
Expected: `✓ Built build/app/outputs/flutter-apk/app-release.apk`

- [ ] **Step 6: Install to device**

```bash
adb install -r "build/app/outputs/flutter-apk/app-release.apk" 2>&1
```
Expected: `Success`

- [ ] **Step 7: Launch app**

```bash
adb shell monkey -p com.brainduel.brain_duel -c android.intent.category.LAUNCHER 1
```

- [ ] **Step 8: Visual smoke check**

Open app and verify:
1. Home tab — gradient "Brain Duel" title visible (lavender→teal), subtitle "Where scholars become champions." visible, bookshelf silhouettes in background, no lag on open
2. Classic card — teal border glow, gradient icon background
3. Versus card — dimmed with primaryDark badge
4. Tap Classic → Daily Classic → confirm new background, teal tile borders
5. Finish a game → result screen → "Daily Classic" title has gradient
6. Open Survival and Rush — new dark purple background visible (no other visual changes)
7. Navigate between tabs — no lag, background consistent
