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

A `StatelessWidget` wrapping a single `CustomPaint` + `RepaintBoundary`.

**Painter: `_ArcaneLibraryPainter extends CustomPainter`**

| Layer | Description | Colors |
|---|---|---|
| 1 | Radial-boosted dark gradient | `#0d0a1e` top → `#160e2e` mid → `#0a0618` bottom |
| 2 | 3 static glow orbs (Rect circles with RadialGradient) | Purple `#8a50dc` 20% opacity, Teal `#2dd2be` 15% opacity |
| 3 | 12 static dust particles (small filled circles, scattered) | Purple + teal, radius 1–2.5px, opacity 30–60% |
| 4 | Bookshelf silhouettes — 3 rows (far/mid/near), each row is a series of rect spines | Far: `#1e0830`, Mid: `#2a1040`, Near: `#3c1660` |
| 5 | Bottom vignette (linear gradient from transparent to `#08040f`) | Covers bottom 20% of canvas |

**`shouldRepaint` → always `false`.**

Widget signature:
```dart
class ArcaneLibraryBackground extends StatelessWidget {
  const ArcaneLibraryBackground({super.key, required this.child});
  final Widget child;
}
```

### Files deleted
- `lib/core/widgets/background/library_background.dart`
- `lib/core/widgets/background/sky_background.dart`
- `lib/core/widgets/background/arcane_background.dart`

### Screens updated (replace old background import + widget)
All 8 consumer screens swap their background widget call to `ArcaneLibraryBackground`:

| Screen | Old Background |
|---|---|
| `home_screen.dart` | `LibraryBackground` |
| `app_shell.dart` | `LibraryBackground` (shell-level) |
| `category_select_screen.dart` | `SkyBackground` |
| `daily_classic_game_screen.dart` | `SkyBackground` |
| `daily_classic_result_screen.dart` | `SkyBackground` |
| `survival_game_screen.dart` | `SkyBackground` |
| `survival_result_screen.dart` | `SkyBackground` |
| `rush_game_screen.dart` | `SkyBackground` |
| `rush_result_screen.dart` | `SkyBackground` |

---

## Section 2 — Home Screen Redesign

**File:** `lib/features/home/presentation/home_screen.dart`

### Header
- **Avatar** — border color: `AppColors.primary` (`#4FD1C5`) teal, 40% opacity, 2px width
- **Title "Brain Duel"** — Fraunces w800 size 32, gradient teal→purple via `ShaderMask`:
  - Colors: `[Color(0xFFe8d8ff), Color(0xFF4FD1C5)]` (lavender → teal)
  - `BlendMode.srcIn`
- **Subtitle** — *"Where scholars become champions."* — Inter w400 size 13, italic, color `AppColors.primary` at 70% opacity
- **Currency badges** — border teal `AppColors.primary` 30% opacity; icon color teal

### Section label
- Text "Game Modes" — Fraunces w700 size 18, color `Color(0xFFc8b8f0)` (soft lavender)
- Decorative underline: `Container` 24×2px, color `AppColors.primary`, margin bottom 12px

### Classic card (active)
- Border: `AppColors.primary` 1.5px width
- Box shadow: `AppColors.primary` blur 12px, spread -2px, opacity 30%
- Icon container gradient: `AppColors.primaryGradient` (`#4FD1C5 → #2FA89D`)
- Title "Classic": Fraunces w700 size 16, color `AppColors.textPrimary`
- Subtitle: Inter w400 size 12, color `AppColors.primary` 70% opacity

### Versus card (disabled)
- Opacity 0.35
- Badge "SOON": border `AppColors.primaryDark`, text color `AppColors.textSecondary`

### `_GlassCard` widget — no change
- Remains identical (BackdropFilter + AppColors.mountainMid/mountainNear gradient)

---

## Section 3 — Daily Classic Screens

### Category Select (`category_select_screen.dart`)
- Title "Pilih Kategori": Fraunces w700, same gradient as home title
- Category card items:
  - Default border: `AppColors.borderSubtle` (no change)
  - Hover/tap: border → `AppColors.primary` 60% opacity
  - Icon background gradient: `AppColors.primaryGradient`

### Daily Game (`daily_classic_game_screen.dart`)
- `RoundProgressBar` fill: `AppColors.primary` (was sky blue)
- `CountdownTimer` default text color: `AppColors.textPrimary` (was sky-tinted)
- `QuestionCard` border: `AppColors.borderSubtle` (unchanged)
- `AnswerOptionTile` selected state border: `AppColors.primary` (was sky blue)

### Daily Result (`daily_classic_result_screen.dart`)
- Header "GAME OVER": Fraunces w800, same gradient as home title
- "Daily Classic" label below header: Inter w500, color `AppColors.primary` 80%
- Score card glow shadow: `AppColors.primary` blur 20px opacity 30%
- Rank progress bar fill: gradient `AppColors.primaryGradient`
- "Play Again" button: `AppColors.primaryGradient` (unchanged — already teal)
- "Home" button border: `AppColors.primary` 60% opacity

---

## Section 4 — Performance & Cleanup

### AnimationController audit
All removed:
- `LibraryBackground` had 2 controllers (`_dustController`, `_glowController`)
- `SkyBackground` had 2 controllers (`_twinkleController`, `_driftController`)
- `ArcaneBackground` had 1 controller (`_pulseController`)

**Total removed: 5 AnimationControllers across 3 deleted files.**

### Survival & Rush screens
Same color accent updates as Daily Classic (Round progress, answer tiles, result screen buttons).

### Widget performance pattern
```dart
class ArcaneLibraryBackground extends StatelessWidget {
  const ArcaneLibraryBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _ArcaneLibraryPainter(),
        child: child,
      ),
    );
  }
}
```

---

## Files Changed Summary

| Action | File |
|---|---|
| **Create** | `lib/core/widgets/background/arcane_library_background.dart` |
| **Delete** | `lib/core/widgets/background/library_background.dart` |
| **Delete** | `lib/core/widgets/background/sky_background.dart` |
| **Delete** | `lib/core/widgets/background/arcane_background.dart` |
| **Modify** | `lib/features/home/presentation/home_screen.dart` |
| **Modify** | `lib/core/widgets/app_shell.dart` |
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
- `flutter test` — all 103 tests pass
- Device smoke test: open each screen, confirm no lag on entry
- Visual: title gradient visible, bookshelf silhouettes visible, teal accents consistent
