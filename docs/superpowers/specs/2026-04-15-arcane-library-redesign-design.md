# Arcane Library Visual Redesign & Performance Fix

**Date:** 2026-04-15
**Scope:** Home screen + all Daily Classic / Survival / Rush screens
**Goal:** Replace heavy animated backgrounds with a single static `ArcaneLibraryBackground`; upgrade typography and color accents throughout; eliminate UI lag.

---

## Decisions

| Question | Decision |
|---|---|
| Visual direction | Arcane Library — deep purple + teal, matching AppColors |
| Background animation | None — pure static CustomPainter (Approach 1) |
| Scope | Home + Daily Classic + Survival + Rush in one change |
| Home subtitle | *"Where scholars become champions."* |

---

## Section 1 — Background Architecture

### New file: `lib/core/widgets/background/arcane_library_background.dart`

Widget implementation pattern:
```dart
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
```

`RepaintBoundary` wraps only the static `CustomPaint + SizedBox.expand()`. The `child` is a sibling in the `Stack`, outside the boundary — fully isolated from the painter's repaint layer.

**Painter: `_ArcaneLibraryPainter extends CustomPainter`**

| Layer | Description | Colors |
|---|---|---|
| 1 | Full-canvas dark gradient (top→bottom) | `Color(0xFF0d0a1e)` → `Color(0xFF160e2e)` → `Color(0xFF0a0618)` |
| 2 | 3 static glow orbs (RadialGradient filled ovals) | Purple `Color(0xFF8a50dc)` 20% opacity, Teal `Color(0xFF2dd2be)` 15% opacity |
| 3 | 12 static dust particles (filled circles, scattered positions) | Purple + teal, radius 1–2.5px, opacity 30–60% |
| 4 | Bookshelf silhouettes — 3 rows (far/mid/near), each row drawn as a series of Rect book spines | Far: `Color(0xFF1e0830)`, Mid: `Color(0xFF2a1040)`, Near: `Color(0xFF3c1660)` |
| 5 | Bottom vignette — LinearGradient from transparent to `Color(0xFF08040f)`, covering bottom 20% | — |

`shouldRepaint` returns `false` unconditionally.

### Background ownership rule
- **`app_shell.dart`** provides `ArcaneLibraryBackground` at the shell level, wrapping its content child. This covers all tab screens (Home, Shop, Card, Event, Leaderboard).
- **`home_screen.dart`** must **remove** its own `LibraryBackground` wrapper — the shell provides the background. Adding a second one would double-paint.
- **All game screens** (`category_select_screen`, `daily_classic_game_screen`, `daily_classic_result_screen`, `survival_game_screen`, `survival_result_screen`, `rush_game_screen`, `rush_result_screen`) are standalone GoRouter routes outside the shell, so each must keep its **own** `ArcaneLibraryBackground(child: ...)` call.

### Files deleted
- `lib/core/widgets/background/library_background.dart`
- `lib/core/widgets/background/sky_background.dart`
- `lib/core/widgets/background/arcane_background.dart`

### Screens updated

| Screen | Action |
|---|---|
| `app_shell.dart` | Replace `LibraryBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `home_screen.dart` | Remove the `LibraryBackground` wrapper entirely (shell covers it) |
| `category_select_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `daily_classic_game_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `daily_classic_result_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `survival_game_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `survival_result_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `rush_game_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |
| `rush_result_screen.dart` | Replace `SkyBackground(child: ...)` → `ArcaneLibraryBackground(child: ...)` |

---

## Section 2 — Home Screen Redesign

**File:** `lib/features/home/presentation/home_screen.dart`

### Header
- **Avatar** — border color: `AppColors.primary.withValues(alpha: 0.4)`, 2px width
- **Title "Brain Duel"** — Fraunces w800 size 32, gradient lavender→teal via `ShaderMask`:
  ```dart
  ShaderMask(
    shaderCallback: (bounds) => const LinearGradient(
      colors: [Color(0xFFe8d8ff), AppColors.primary],
    ).createShader(bounds),
    blendMode: BlendMode.srcIn,
    child: Text('Brain Duel', style: TextStyle(fontFamily: 'Fraunces', fontSize: 32, fontWeight: FontWeight.w800)),
  )
  ```
- **Subtitle** — *"Where scholars become champions."* — `TextStyle(fontFamily: 'Inter', fontSize: 13, fontStyle: FontStyle.italic)`, color `AppColors.primary.withValues(alpha: 0.7)`
- **Currency badges** — border `AppColors.primary.withValues(alpha: 0.3)`, icon color `AppColors.primary`

### Section label
- Text "Game Modes" — `TextStyle(fontFamily: 'Fraunces', fontSize: 18, fontWeight: FontWeight.w700)`, color `Color(0xFFc8b8f0)`
- Decorative underline below label: `Container(width: 24, height: 2, color: AppColors.primary)` with `SizedBox(height: 12)` below it

### Classic card (active)
- `_GlassCard` border: `AppColors.primary` at full opacity, 1.5px width
- `_GlassCard` glow shadow (boxShadow): `AppColors.primary.withValues(alpha: 0.3)`, blurRadius 12, spreadRadius -2
- Icon container: replace existing `color: accent.withValues(alpha: 0.18)` with:
  ```dart
  Container(
    decoration: BoxDecoration(
      gradient: AppColors.primaryGradient,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(...),
  )
  ```
- Title "Classic": `TextStyle(fontFamily: 'Fraunces', fontSize: 16, fontWeight: FontWeight.w700)`, color `AppColors.textPrimary`
- Subtitle "Daily · Survival · Rush": `TextStyle(fontFamily: 'Inter', fontSize: 12)`, color `AppColors.primary.withValues(alpha: 0.7)`

### Versus card (disabled)
- Wrap entire Versus card in `Opacity(opacity: 0.35, child: ...)`
- Badge "SOON" container:
  ```dart
  BoxDecoration(
    color: AppColors.primaryDark.withValues(alpha: 0.15),
    border: Border.all(color: AppColors.primaryDark, width: 1),
    borderRadius: BorderRadius.circular(20),
  )
  ```
- Badge text: `TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w600)`, color `AppColors.textSecondary`

### `_GlassCard` widget — no change
Remains identical: `BackdropFilter` blur 16px + `mountainMid`/`mountainNear` gradient + default border `Colors.white.withValues(alpha: 0.12)`.

---

## Section 3 — Daily Classic Screens

### Category Select (`category_select_screen.dart`)
- Title "Pilih Kategori": apply same `ShaderMask` gradient as home title
- Each category icon container: replace plain color with `BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(12))`

### Daily Game (`daily_classic_game_screen.dart`)
- `RoundProgressBar` fill color: change to `AppColors.primary`
- `CountdownTimer` — **no change to color logic** (existing 3-state: `AppColors.correct` > 3s, `AppColors.warning` 1–3s, `AppColors.wrong` < 1s is correct and intentional)
- `QuestionCard` border: no change (`AppColors.borderSubtle`)
- `AnswerOptionTile` selected-state border: change to `AppColors.primary`

### Daily Result (`daily_classic_result_screen.dart`)
- **"GAME OVER" eyebrow label** (`AppTypography.labelSmall`): no change — keep `color: AppColors.textSecondary, letterSpacing: 3`
- **"Daily Classic" large title** (`AppTypography.displayMedium`): apply same `ShaderMask` gradient as home title, replacing the current `color: AppColors.textPrimary`
- Score card glow shadow: no change — already `AppColors.primary.withValues(alpha: 0.3)`
- Rank tier progress bar: **no change** — keep existing tier-specific colors (Bronze = `AppColors.rarityCommon`, Silver = `AppColors.textSecondary`, Gold = `AppColors.rarityLegendary`, Platinum = `AppColors.primary`). These already use AppColors tokens correctly.
- "Play Again" button: no change — already `AppColors.primaryGradient`
- "Home" button border: change `AppColors.borderStrong` → `AppColors.primary.withValues(alpha: 0.6)`

---

## Section 4 — Survival & Rush Screens

### Survival game (`survival_game_screen.dart`) — background swap only
- Replace `SkyBackground` → `ArcaneLibraryBackground`
- No color changes: existing accents (`AppColors.primary` for correctCount badge, `AnswerOptionTile`, `CountdownTimer`) are already correct

### Survival result (`survival_result_screen.dart`) — background swap only
- Replace `SkyBackground` → `ArcaneLibraryBackground`
- No color changes: "Play Again" already uses `AppColors.primaryGradient`, score already uses `AppColors.primary`

### Rush game (`rush_game_screen.dart`) — background swap only
- Replace `SkyBackground` → `ArcaneLibraryBackground`
- No color changes: `timerColor` dynamic logic (`AppColors.primary` > 10s, `AppColors.rarityLegendary` ≤ 10s) is intentional urgency feedback — keep as is

### Rush result (`rush_result_screen.dart`) — background swap only
- Replace `SkyBackground` → `ArcaneLibraryBackground`
- No color changes: buttons already use `AppColors.primaryGradient` / `AppColors.primary`

---

## Section 5 — Performance & Cleanup

### AnimationControllers removed

| File (deleted) | Controllers removed |
|---|---|
| `library_background.dart` | `_dustController`, `_glowController` (2) |
| `sky_background.dart` | `_twinkleController`, `_driftController` (2) |
| `arcane_background.dart` | `_twinkleController`, `_pulseController` (2) |

**Total removed: 6 AnimationControllers across 3 deleted files.**

### Performance improvement summary

| Metric | Before | After |
|---|---|---|
| AnimationControllers | 6 | 0 |
| Background repaints | Every frame (60fps) | Once on init |
| GPU cost per frame | ~10–15ms | ~0ms |

---

## Files Changed Summary

| Action | File |
|---|---|
| **Create** | `lib/core/widgets/background/arcane_library_background.dart` |
| **Delete** | `lib/core/widgets/background/library_background.dart` |
| **Delete** | `lib/core/widgets/background/sky_background.dart` |
| **Delete** | `lib/core/widgets/background/arcane_background.dart` |
| **Modify** | `lib/core/widgets/app_shell.dart` |
| **Modify** | `lib/features/home/presentation/home_screen.dart` |
| **Modify** | `lib/features/daily/presentation/category_select_screen.dart` |
| **Modify** | `lib/features/daily/presentation/daily_classic_game_screen.dart` |
| **Modify** | `lib/features/daily/presentation/daily_classic_result_screen.dart` |
| **Modify** | `lib/features/survival/presentation/survival_game_screen.dart` |
| **Modify** | `lib/features/survival/presentation/survival_result_screen.dart` |
| **Modify** | `lib/features/rush/presentation/rush_game_screen.dart` |
| **Modify** | `lib/features/rush/presentation/rush_result_screen.dart` |

---

## Testing

- `flutter analyze` — no issues
- `flutter test` — all 103 tests pass (no logic changes, layout only)
- Device smoke test:
  - Open Home tab — no lag, background visible, no double-paint
  - Open Daily Classic → game → result — teal accents consistent
  - Open Survival, Rush — backgrounds updated, existing accents unchanged
  - Verify "Daily Classic" / "Survival" / "Rush" titles show gradient; eyebrow labels stay plain
