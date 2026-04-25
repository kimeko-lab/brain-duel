# Brain Duel — UI Redesign Design Spec

**Date:** 2026-04-11
**Author:** kimeko (FE)
**Status:** Approved for implementation

---

## Overview

Redesign the Brain Duel main shell from a single-screen layout to a full app shell with bottom navigation and a Clash Royale-inspired "Royal Arcane" visual theme. Scope is the **Main tab only**; Shop, Card, Event, and Leaderboard tabs are scaffolded as empty placeholders.

---

## 1. Theme — Royal Arcane

A dark fantasy aesthetic inspired by Clash Royale: deep purple backgrounds, violet neon glows, fire-orange accent for currency and highlights. Lightweight — no additional packages beyond what is already in pubspec.

### Theme file strategy

`app_theme.dart` is **additive** — it introduces new color constants used exclusively by the shell, HomeScreen, and ClassicModeSheet. Existing files `app_colors.dart`, `app_spacing.dart`, `app_typography.dart`, and `SkyBackground` are **kept unchanged**. Game screens (daily, survival, rush) continue importing from the old files. There is no conflict because game screens run outside the shell scaffold.

### Color Tokens (`lib/core/theme/app_theme.dart`)

| Token | Value | Usage |
|---|---|---|
| `bgDeep` | `#130820` | Scaffold background start |
| `bgMid` | `#1e0b35` | Scaffold background end (radial gradient) |
| `surface` | `rgba(255,255,255,0.06)` | Card / sheet background |
| `borderSubtle` | `rgba(200,50,255,0.20)` | Card borders |
| `primary` | `#8a1aaa → #cc32ff` | Primary CTA gradient |
| `primaryGlow` | `rgba(200,50,255,0.40)` | Box shadow glow |
| `accent` | `#ff9a32` | Currency, active highlights |
| `accentGlow` | `rgba(255,154,50,0.35)` | Currency glow |
| `textPrimary` | `#ffffff` | Body text |
| `textMuted` | `rgba(255,255,255,0.50)` | Secondary text |
| `navBg` | `#0e061a` | Bottom nav background |
| `navActive` | `#cc32ff` | Active nav icon/label |
| `navInactive` | `rgba(255,255,255,0.35)` | Inactive nav icon/label |

Background is a full-screen `RadialGradient` centered slightly above screen center, from `bgDeep` to `bgMid`.

### Typography

Use `GoogleFonts.orbitron` for headings and mode labels (gives sci-fi/arcane feel). `google_fonts: ^6.2.1` is confirmed present in `pubspec.yaml`. Orbitron will be fetched from the network on first run; subsequent runs use the cached font. Fallback (if font unavailable offline) is `TextStyle(fontFamily: null)` — system sans-serif. All existing game screens keep their existing typography unchanged.

---

## 2. Architecture — App Shell

### Router approach: `StatefulShellRoute` (go_router)

**Decision:** Use `StatefulShellRoute.indexedStack` from go_router. This is the definitive approach — not the manual `context.go()` pattern. Reasons: (1) active tab index stays in sync with router state automatically via `navigationShell.currentIndex`, so back-navigation and deep links work correctly; (2) each branch maintains its own navigator stack; (3) cleaner separation.

**Migration note:** The existing flat `GoRoute(path: '/')` that maps to `HomeScreen` is **removed** and replaced by Branch 0 below. This is the only route being removed.

```
GoRouter(initialLocation: '/')

StatefulShellRoute.indexedStack (builder: AppShell)
  Branch 0: /          → HomeScreen        (branch index 0 = Main)
  Branch 1: /shop      → ShopScreen        (placeholder)
  Branch 2: /card      → CardScreen        (placeholder)
  Branch 3: /event     → EventScreen       (placeholder)
  Branch 4: /leaderboard → LeaderboardScreen (placeholder)

Standalone GoRoutes (outside shell, full-screen — no bottom nav):
  /daily/select         ← matches existing router path exactly
  /daily/game/:category
  /daily/result
  /survival/game
  /survival/result
  /rush/game
  /rush/result
```

**Branch vs visual tab order:** Branch index 0 = Main tab (path `/`). This is the `initialLocation`. The visual tab bar order is Shop, Card, **Main**, Event, Rank — Main appears at visual position 2 (center). AppShell maps visual tap position → branch index using:
```dart
const _branchForVisualIndex = [1, 2, 0, 3, 4]; // Shop→1, Card→2, Main→0, Event→3, Rank→4
```
When user taps visual position `i`, call `navigationShell.goBranch(_branchForVisualIndex[i])`.
Active visual position is determined by reverse lookup of `navigationShell.currentIndex`.

Game screens are top-level `GoRoute`s defined **outside** the `StatefulShellRoute` — they push on top of the shell navigator so bottom nav disappears during gameplay.

### AppShell widget (`lib/core/widgets/app_shell.dart`)

- Receives `StatefulNavigationShell navigationShell` as constructor parameter
- Active tab index = `navigationShell.currentIndex` (no local `_selectedIndex` needed)
- Tab tap: `navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex)`
- **Background:** `AppShell.build()` returns a `Stack` — bottom layer is a full-screen `Container` with `BoxDecoration(gradient: RadialGradient(bgDeep→bgMid, center: Alignment(0, -0.3)))`, top layer is `Column([Expanded(child: navigationShell), _BottomNavBar()])`
- `HomeScreen` scaffold is `backgroundColor: Colors.transparent` — it inherits the shell background
- `SkyBackground` widget used by the old HomeScreen is removed from HomeScreen only; game screens that use it are untouched
- Bottom nav bar: custom `_BottomNavBar` widget — a `Container` (height 64 + safe area padding) with `navBg` color + top border `borderSubtle`. Contains a `Row` of 5 `_NavItem` widgets

### _NavItem specification

| Index | Label | Icon (inactive) | Icon (active) |
|---|---|---|---|
| 0 | Shop | `Icons.storefront_outlined` | `Icons.storefront` |
| 1 | Card | `Icons.style_outlined` | `Icons.style` |
| 2 | Main | `Icons.home_outlined` | `Icons.home` |
| 3 | Event | `Icons.celebration_outlined` | `Icons.celebration` |
| 4 | Rank | `Icons.leaderboard_outlined` | `Icons.leaderboard` |

Each `_NavItem` is a `GestureDetector` wrapping a `Column(icon + label)`. Active state: icon color `navActive` + 3×20px rounded pill indicator above icon with `primary` gradient + `BoxShadow(primaryGlow)`. Inactive state: icon color `navInactive`, no indicator.

---

## 3. Main Screen Layout (`lib/features/home/presentation/home_screen.dart`)

### Structure (top to bottom)

```
Scaffold (transparent — background from AppShell)
  SafeArea
    Column
      _TopBar          ← currency + avatar row
      Spacer(flex: 1)
      _HeroTitle       ← "BRAIN DUEL" wordmark + tagline
      Spacer(flex: 1)
      _ModeButtons     ← Classic + Versus cards
      Spacer(flex: 2)
```

### _TopBar

```
Row (mainAxisAlignment: spaceBetween,
     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12))
  _CurrencyBadge(icon: bookSilver, amount: 240, color: white)
  _AvatarWidget(size: 52)
  _CurrencyBadge(icon: bookGold, amount: 80, color: accent/orange)
```

**_CurrencyBadge:** `Container` with `surface` background + `borderSubtle` border + border-radius 24. Icon is a styled `Container` (gradient fill circle, 28px) with a book SVG-like shape drawn via `CustomPainter` or a stylized `Icon(Icons.menu_book)` with color fill. Amount text in `textPrimary` bold.

**_AvatarWidget:** 52×52 circle, purple gradient ring (2px border, `primary` gradient), inner circle shows a placeholder brain/person icon in white. Tap → no-op for now (profile screen future).

### _HeroTitle

```
Column (crossAxisAlignment: center)
  Text("BRAIN DUEL", style: Orbitron 28 bold, letterSpacing 4, white)
  SizedBox(8)
  Text("Test your mind. Duel the world.", style: 13 textMuted italic)
```

Subtle glow: `TextStyle` with `shadows: [Shadow(color: primaryGlow, blurRadius: 12)]` on the title.

### _ModeButtons

Two buttons stacked vertically with 12px gap, horizontal padding 24px.

**Classic Button (enabled):**
```
GestureDetector(onTap: _showClassicSheet)
  Container(
    height: 72,
    decoration: BoxDecoration(
      gradient: LinearGradient(#8a1aaa → #cc32ff, 135°),
      borderRadius: 16,
      boxShadow: [BoxShadow(primaryGlow, blurRadius: 20, offset: (0,6))],
    )
    Row(padding: 20h)
      _ModeIcon(type: classic)   ← styled icon widget (see below)
      SizedBox(16)
      Column
        Text("CLASSIC", Orbitron 16 bold white)
        Text("Daily · Survival · Rush", 12 textMuted)
      Spacer()
      Icon(Icons.chevron_right, white 70%)
  )
```

**Versus Button (disabled/coming soon):**
```
Container(
  height: 72,
  decoration: BoxDecoration(
    color: surface,
    border: Border.all(borderSubtle),
    borderRadius: 16,
  )
  Row(padding: 20h)
    _ModeIcon(type: versus, muted: true)
    SizedBox(16)
    Column
      Text("VERSUS", Orbitron 16 bold textMuted)
      Text("Coming Soon", 12 textMuted)
    Spacer()
    Container("SOON" badge, orange/muted, small pill)
)
```

### _ModeIcon (immersive icons)

Each mode icon is a 44×44 `Container` with:
- Gradient circular background (lighter version of primary for Classic, muted for Versus)
- Inner `CustomPaint` OR layered `Stack` of styled widgets

| Mode | Icon approach |
|---|---|
| Classic | `Icons.auto_stories` (open book) in white, container gradient `#5e1a8a → #a020f0`, glow shadow |
| Versus | `Icons.sports_kabaddi` (two figures) in muted white, container filled `surface` |

Bottom nav icons follow same principle: each tab icon is a 36×36 styled container:
- **Inactive:** icon `navInactive` color, plain
- **Active:** icon `navActive` color + small gradient pill indicator (4px wide, `primary` gradient) below icon, subtle glow

---

## 4. Classic Mode Sheet (`lib/features/home/presentation/widgets/classic_mode_sheet.dart`)

`showModalBottomSheet` with `isScrollControlled: false`, `backgroundColor: transparent`, `shape: RoundedRectangleBorder(topLeft/Right 24px)`.

Inner widget:
```
Container(
  decoration: BoxDecoration(
    color: #1a0830,
    border: top border rgba(200,50,255,0.3),
    borderRadius: top 24,
  )
  Column(padding: 24)
    Row
      Text("Pilih Mode", Orbitron 18 bold white)
      Spacer()
      IconButton(Icons.close, textMuted) → Navigator.pop
    SizedBox(16)
    _ModeCard(type: dailyClassic)
    SizedBox(10)
    _ModeCard(type: survival)
    SizedBox(10)
    _ModeCard(type: rush)
    SizedBox(24)
)
```

### _ModeCard

```
GestureDetector(onTap: () { Navigator.of(context).pop(); context.go(route); })
  Container(
    padding: 16,
    decoration: BoxDecoration(surface bg, borderSubtle border, radius 14)
    Row
      _ModeIcon(type, size: 48)
      SizedBox(14)
      Column
        Text(name, Orbitron 15 bold white)
        Text(description, 12 textMuted)
      Spacer()
      Icon(chevron_right, textMuted)
  )
```

**Modal dismissal:** `showModalBottomSheet` is a Flutter Navigator overlay (not a go_router route), so use `Navigator.of(context).pop()` — NOT `context.pop()`. Using `context.pop()` (go_router) on a modal sheet would attempt to pop the underlying route stack and is incorrect here. Both the close `IconButton` and each `_ModeCard` tap use `Navigator.of(context).pop()` to dismiss the sheet, then `context.go(route)` to navigate.

| Mode | Route | Description |
|---|---|---|
| Daily Classic | `/daily/select` | Pilih kategori, 5 soal, 10s/soal |
| Survival | `/survival/game` | Jawab salah = game over |
| Rush | `/rush/game` | 60 detik, jawab sebanyak mungkin |

Mode icons in sheet are 48×48 with individual gradient colors:
- Daily Classic: `#1a4a8a → #2d7aff` (blue — cerebral)
- Survival: `#8a1a1a → #cc2222` (red — danger)
- Rush: `#8a5a1a → #cc9a22` (amber — speed)

---

## 5. Files Changed

| File | Action |
|---|---|
| `lib/core/theme/app_theme.dart` | **New** — color + text theme tokens |
| `lib/core/widgets/app_shell.dart` | **New** — bottom nav shell scaffold |
| `lib/core/router/app_router.dart` | **Modify** — add ShellRoute, placeholder tab routes |
| `lib/features/home/presentation/home_screen.dart` | **Rewrite** — Main tab content |
| `lib/features/home/presentation/widgets/classic_mode_sheet.dart` | **New** — mode picker sheet |
| `lib/features/shop/presentation/shop_screen.dart` | **New** — empty placeholder |
| `lib/features/card/presentation/card_screen.dart` | **New** — empty placeholder |
| `lib/features/event/presentation/event_screen.dart` | **New** — empty placeholder |
| `lib/features/leaderboard/presentation/leaderboard_screen.dart` | **New** — empty placeholder |

Placeholder screens live in their own top-level feature folders (not under `home/`) so they can be developed independently later without moving files.

**Not changed:** All game screens (daily, survival, rush), notifiers, repositories, scoring logic.

---

## 6. Dependencies

No new pub packages required. Uses only:
- `google_fonts` (already in pubspec) — Orbitron
- `go_router` (already in pubspec) — ShellRoute
- `flutter_riverpod` (already in pubspec) — unchanged

---

## 7. Out of Scope

- Shop, Card, Event, Leaderboard content (placeholders only)
- Profile screen / avatar upload
- Currency persistence (hardcoded `240` / `80` for now)
- Versus mode implementation
- Animations beyond what `flutter_animate` already provides in existing screens
