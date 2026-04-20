# Brain Duel — Polish Pass Design

**Date:** 2026-04-20
**Scope:** 3 localized visual/typography refactors. No gameplay, state, or routing changes.

## Problem

Three unrelated polish items surfaced in user review of the current build:

1. **Survival + Rush result screens** use an older visual direction — `ArcaneLibraryBackground` + glass cards with `BackdropFilter(blur: 16)` — that diverges from Daily Classic's result screen (plain dark + solid cards). The inconsistency is accidental, not intentional.
2. **Home screen mode cards** (Classic / Survival / Rush) have weak visual hierarchy: small 40px icons, 13px title, thin accent bar, left-aligned content with significant empty space. Cards don't communicate "pick me" energy.
3. **Event tab 7-day streak `DayBox`** has broken internal hierarchy: on mobile each box is ~45px wide, icon is 12px, reward amount is 9px (the smallest text despite being the most important info), day label "D1" is 8px. Placeholder icon `·` mixes inconsistently with emoji `🎁`, `✓`, `★`, `🃏`.

All three are isolated visual concerns. None affect gameplay, state, data model (except a minor `DayBox` prop split), or routing.

## Direction

Three independent fixes, each scoped to specific files. Event tab's manga theme stays event-exclusive; Daily/Survival/Rush stay cosmic-dark. The 7-day streak lives inside the Event tab and stays on manga paper theme.

### Section 1 — Survival + Rush result screens match Daily Classic

Survival and Rush result screens adopt Daily Classic's exact visual pattern. Daily Classic's screen (`lib/features/daily/presentation/daily_classic_result_screen.dart`) is the source of truth:

- Plain `Scaffold(backgroundColor: Color(0xFF06081F))` — **no `ArcaneLibraryBackground` wrapper**.
- Local hardcoded color tokens declared as **top-level `const Color`** at the top of each result file (not inside the class, not via `AppColors.*`): `_bg = 0xFF06081F`, `_cardBg = 0xFF111428`, `_border = 0xFF2A2F52`, `_textSub = 0xFF9CA3AF`, `_primary = 0xFF6366F1`. These do not currently exist in `survival_result_screen.dart` / `rush_result_screen.dart` — they are being introduced.
- Solid `_DarkCard` (no `BackdropFilter`, no `ClipRRect` blur, no `dart:ui` import). Copy the `_DarkCard` class definition verbatim from `daily_classic_result_screen.dart`.
- Score display uses `fontFamily: 'Fraunces'`, `fontSize: 56`, `fontWeight: w900`, `letterSpacing: -1.5`, with a single `Shadow(color: 0x556366F1, blurRadius: 24)`. This replaces `AppTypography.displayMedium` with its two-layer primary-alpha glow.
- Header labels ("GAME OVER" / "TIME'S UP!") and section labels ("SCORE", "RANK PROGRESS" etc.) use `fontFamily: 'Inter'`, `fontSize: 11`, `fontWeight: w700`, `letterSpacing: 3`, color `_textSub`.
- Buttons: `_PrimaryButton` (indigo-to-green gradient with primary-alpha glow shadow, text color `0xFF06081F`) and `_SecondaryButton` (`_DarkCard` with primary-alpha 0.40 border, text color `_textSub`). Copy both classes verbatim from Daily Classic.
- Animation delay chain unchanged: header 0ms, score 200ms, message 350ms, crystals 500ms, optional chip 700ms, primary button 850ms, secondary 950ms.

**Mode-specific content preserved:**

| | Survival | Rush |
|---|---|---|
| Header eyebrow | "GAME OVER" | "TIME'S UP!" |
| Header title | "Survival" | "Rush" |
| Below-score message | `"$correctCount correct in a row!"` if > 0 else `"Better luck next time!"` | Two lines: `"$totalCount questions in 60s!"` (primary color, bold) + `"$correctCount / $totalCount correct"` (`_textSub`) |
| Optional chip | `STREAK: $correctCount` if > 0 (primary-tinted pill, letter-spacing 2) | none |
| Play Again route | `/survival/game` | `/rush/game` |

**Intentionally dropped:**
- The Daily Classic `_buildRankProgress(score)` block and its `_RankTier` / `_tierForScore` helpers. Survival and Rush have unbounded scoring, so tier progression would misrepresent player progress.

**Imports to remove in both files:** `dart:ui`, `../../../core/theme/app_typography.dart`, `../../../core/theme/app_colors.dart`, `../../../core/widgets/background/arcane_library_background.dart`. `app_spacing.dart` stays.

### Section 2 — Home mode cards (Classic / Survival / Rush)

Target file: `lib/features/home/presentation/home_screen.dart`, classes `_StatCard` and `_ModeData`. `_buildStatCards()` height, spacing, and horizontal `ListView.builder` pattern are preserved; only the inside of each card changes.

**Layout change (vertical stack, centered):**
- Card size: `width: 110` preserved. `padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16)` (was `12`/`12`).
- Card height container (`_buildStatCards` SizedBox) grows from 106 → 130 to fit the 56px medallion + subtitle.
- Column changes: `crossAxisAlignment: CrossAxisAlignment.center` (was `start`), `mainAxisAlignment: MainAxisAlignment.center`.

**Icon medallion (replaces the current 40×40 tinted square):**
- 56×56, `borderRadius: 16`.
- Decoration: `LinearGradient(begin: topLeft, end: bottomRight, colors: modeGradient)`. When inactive, both stops get `.withValues(alpha: 0.35)` so color identity survives but the card is muted.
- Single `BoxShadow(color: gradientStart.withValues(alpha: active ? 0.45 : 0.20), blurRadius: 18, spreadRadius: -4)` for glow.
- Child `Icon(data.icon, size: 28, color: Colors.white)` — icon color is always white now (was mode-color tint).

**Mode gradient tuples** (added as a new field on `_ModeData`):

| Mode | Gradient start | Gradient end |
|---|---|---|
| Classic | `0xFF6366F1` | `0xFF3730A3` |
| Survival | `0xFFFF6B6B` | `0xFFB91C1C` |
| Rush | `0xFFFACC15` | `0xFFB45309` |

**Typography:**
- Title: `fontFamily: 'Inter'`, `fontSize: 14`, `fontWeight: w800`, `textAlign: center`. Color white on active, `0xFFCFD9E0` on inactive. SizedBox above: 10.
- **New subtitle:** `fontFamily: 'Inter'`, `fontSize: 9`, `fontWeight: w700`, `letterSpacing: 1.0`, text uppercase. Color: mode `gradientStart` on active, `_textSub` on inactive. SizedBox above: 4.

**Subtitle strings** (added as a new field on `_ModeData`):

| Mode | Subtitle |
|---|---|
| Classic | `DAILY` |
| Survival | `ENDLESS` |
| Rush | `60 SEC` |

**Dropped:** The 3×20 accent bar under the title (`AnimatedCrossFade` + `Container(height: 3, width: 20)`). The gradient + glow already signals active state; the bar is redundant.

**`_ModeData` struct changes:**
- **Remove:** `String subtitle` (currently empty strings), `Color color`, `IconData icon` is kept.
- **Add:** `List<Color> gradientColors` (length 2), `String tagline`.
- No consumers outside `_StatCard` reference `_ModeData.color` (verified: `_buildClassicBanner` uses top-level `_primary` constant, not `modes[_activeModeCard].color`), so removal is clean.

**Unchanged:** `onTap` behavior (including the `_showModeSheet` call for Survival/Rush), `_activeModeCard` state wiring, haptic feedback, `ListView.builder` outer structure.

### Section 3 — Event tab 7-day streak `DayBox` internal polish

Target file: `lib/features/event/presentation/widgets/day_box.dart`. Layout contract (7 equal-width boxes in a `Row` consumed by `event_screen.dart`) unchanged. Only the contents of each box change.

**API change (call-site breaking):**
- Remove `final String reward;` (current: takes a pre-formatted string like `"50💎"` / `"1📘"` / `"🃏"`).
- Add `final int rewardAmount;` and `final String rewardKind;`.
- Semantics label updates accordingly: `"Day $dayNumber, $state, $rewardAmount $rewardKind"`.

**Reward kind taxonomy** (the current `_rewards` list contains 3 categories):

| Current string | New (amount, kind) | Notes |
|---|---|---|
| `"50💎"` / `"100💎"` / `"200💎"` | `(50, "GEM")` / `(100, "GEM")` / `(200, "GEM")` | Gem/crystal rewards |
| `"1📘"` / `"2📗"` | `(1, "CARD")` / `(2, "CARD")` | Knowledge card (📘 and 📗 both normalize to `"CARD"` — visual distinction was cosmetic only) |
| `"🃏"` (day 7) | `(1, "JOKER")` | Final-day special: joker/wildcard reward |

**Icon system (hardcoded inside `build()`, no new prop):**

| State | Day 1–6 | Day 7 |
|---|---|---|
| Claimed | `✓` | `✓` |
| Today | `🎁` | `🏆` |
| Future | `💎` | `👑` |

Dropped: `·` (placeholder dot) and `★` (ad-hoc day-7 marker) — both replaced by the state-aware icon system above.

**Internal layout (box min-height ≈ 64px, `Column`, center-aligned):**
```
padding: horizontal 3, vertical 10
child: Column(mainAxisAlignment: center, crossAxisAlignment: center):
  Text(icon, style: TextStyle(fontSize: 14, color: fg, height: 1.0))   // decoration
  SizedBox(height: 5)
  Text('$rewardAmount',
       style: EventTokens.bebas(size: 14, weight: w900, color: fg))    // HERO
  Text(rewardKind,
       style: EventTokens.bebas(size: 8, weight: w700,
                                letterSpacing: 1.2, color: fg))        // SUPPORT
```

Gap between amount and kind: 0 (baseline tight, kind reads as a caption).

**Dropped:** The `Text('D$dayNumber', ...)` line. Position in the row already communicates day index; keeping it was redundancy noise at 8px.

**State color mapping unchanged** (`_isClaimed` → ink/paper, `_isToday` → red/white, default → white/ink). Today-state offset transform (-1, -1) and shadow unchanged. Border width 2px unchanged.

**Call-site update in `event_screen.dart`** (single `DayBox(...)` call fed by the `_rewards` const list at line ~261):
- Reshape the `static const _rewards = ['50💎', '1📘', '100💎', '1📘', '200💎', '2📗', '🃏']` list into a `static const List<({int amount, String kind})> _rewards` of 7 record entries: `(amount: 50, kind: 'GEM')`, `(amount: 1, kind: 'CARD')`, `(amount: 100, kind: 'GEM')`, `(amount: 1, kind: 'CARD')`, `(amount: 200, kind: 'GEM')`, `(amount: 2, kind: 'CARD')`, `(amount: 1, kind: 'JOKER')`.
- Update the `_DailyLoginPanel` field `final List<String> rewards` → `final List<({int amount, String kind})> rewards` (or equivalent typedef).
- Update the single `DayBox(...)` construction (line ~474) from `reward: rewards[i]` → `rewardAmount: rewards[i].amount, rewardKind: rewards[i].kind`.
- The panel header icon (`🎁`) is unaffected — it lives outside `DayBox`.

## Scope

**In scope:**
- `lib/features/survival/presentation/survival_result_screen.dart` — rewrite (no new files)
- `lib/features/rush/presentation/rush_result_screen.dart` — rewrite (no new files)
- `lib/features/home/presentation/home_screen.dart` — modify `_ModeData`, `_StatCard`, `_buildStatCards`
- `lib/features/event/presentation/widgets/day_box.dart` — modify API + build
- `lib/features/event/presentation/event_screen.dart` — update `DayBox` call-sites only

**Out of scope:**
- Daily Classic result screen (already the reference pattern)
- Event tab design (already approved + shipped)
- Game screens (Survival/Rush/Daily) — not mentioned in feedback
- Test updates beyond keeping existing tests green
- Routing, state management, data models beyond `DayBox` prop split
- Game mode `crystal_reward_widget.dart` — shared widget, unchanged
- Removing `ArcaneLibraryBackground` from the codebase — may still be used elsewhere (not audited here)

## Component Inventory

| Component | File | Change type |
|---|---|---|
| `SurvivalResultScreen` | `lib/features/survival/presentation/survival_result_screen.dart` | Rewrite body + helpers; copy `_DarkCard`/`_PrimaryButton`/`_SecondaryButton` from Daily Classic |
| `RushResultScreen` | `lib/features/rush/presentation/rush_result_screen.dart` | Rewrite body + helpers; copy `_DarkCard`/`_PrimaryButton`/`_SecondaryButton` from Daily Classic |
| `_GlassCard` (both files) | (above) | Delete |
| `_ModeData` | `lib/features/home/presentation/home_screen.dart` | Replace `subtitle`/`color` with `gradientColors`/`tagline` |
| `_StatCard` | `lib/features/home/presentation/home_screen.dart` | Rewrite `build()`: new medallion, new typography, drop accent bar |
| `_buildStatCards()` | `lib/features/home/presentation/home_screen.dart` | Bump `SizedBox(height: 106)` → `130`; pass new `_ModeData` fields |
| `DayBox` | `lib/features/event/presentation/widgets/day_box.dart` | Swap `reward` → `rewardAmount`+`rewardKind`; rewrite icon selection + internal layout |
| `event_screen.dart` `_rewards` const + `_DailyLoginPanel.rewards` field + single `DayBox(...)` call | `lib/features/event/presentation/event_screen.dart` | Reshape list from `List<String>` to `List<({int amount, String kind})>` (7 entries); update `_DailyLoginPanel.rewards` field type; update the lone `DayBox(...)` constructor args to `rewardAmount:` + `rewardKind:` |

Copy-from-Daily-Classic rationale: `_DarkCard` is already duplicated locally in each result file (it was `_GlassCard` there). Keeping the copy-local pattern preserves the existing file boundaries and avoids introducing a new shared widget location in this pass.

## Implementation Notes

- **`EventTokens.bebas()` weight:** The helper forwards `weight` unmodified to `GoogleFonts.bebasNeue(fontWeight: ...)`. Bebas Neue on Google Fonts is a single-weight display face, so `w900` renders identically to `w400` — the weight arg has no visual effect but is kept for semantic clarity and parity with other display-font call-sites in the event feature.
- **Icon characters** (`✓`, `🎁`, `🏆`, `💎`, `👑`) render at 14px — on Android emoji fonts these are monospace-square at this size. No overflow; text renders in normal line-height 1.0.
- **Gradient medallion inactive state:** `alpha: 0.35` on both stops means the color is visible but dimmed. Icon color stays white — this is intentional, because white icon on dimmed-gradient still reads as "mode icon", whereas flipping to mode-color ink on dim bg would lose the shape signal.
- **No new packages.** `google_fonts` is already installed; `flutter_animate` is already used in both result screens.

## Typography Tokens Used

| Use | Font | Size | Weight | Where |
|---|---|---|---|---|
| Result screen score | `Fraunces` | 56 | w900 | Survival/Rush result |
| Result screen header title | `Inter` | 32 | w800 | Survival/Rush result |
| Result screen eyebrow label | `Inter` | 11 | w700 (letter-spacing 3) | Survival/Rush result |
| Result screen button label | `Inter` | 14 | w700 | Survival/Rush result |
| Mode card title | `Inter` | 14 | w800 | Home mode cards |
| Mode card subtitle | `Inter` | 9 | w700 (letter-spacing 1) | Home mode cards |
| DayBox amount | `Bebas Neue` (via `EventTokens.bebas`) | 14 | w900 | Event DayBox |
| DayBox kind | `Bebas Neue` (via `EventTokens.bebas`) | 8 | w700 (letter-spacing 1.2) | Event DayBox |
| DayBox icon | system | 14 | — | Event DayBox |

## Accessibility

- Score/message text contrast: white on `0xFF06081F` = 15.8:1 (AAA). `_textSub = 0xFF9CA3AF` on `0xFF06081F` = 6.7:1 (AA).
- Mode card subtitle `0xFF6366F1` on `0xFF112226` = 4.4:1 (AA-large only). Acceptable because text is 9px w700 uppercase — treat as decoration; `Semantics(label: "$title, $tagline")` handles the screen reader case.
- DayBox Semantics label preserved; updates to include rewardAmount + rewardKind.
- No `textScaler` clamps changed; Event tab clamp (1.3×) continues to apply to `DayBox`.

## Dark Mode

No change. Home + Survival/Rush result = hardcoded cosmic dark. Event = hardcoded manga paper. Neither reads `Theme.brightness`.

## Loading States

No change. Result screens receive data through route `extra` — no async. DayBox state is read from the existing mock `_claimedUpTo` / `_todayClaimed` / `_todayIndex` in `event_screen.dart`. Home mode cards are always present.

## Falsifiable Acceptance Criteria

1. `SurvivalResultScreen.build()` contains no reference to `ArcaneLibraryBackground`, `BackdropFilter`, or `_GlassCard`. `grep` for those symbols in `survival_result_screen.dart` returns 0 matches.
2. Same for `RushResultScreen` in `rush_result_screen.dart`.
3. `SurvivalResultScreen` `_bg`, `_cardBg`, `_border`, `_textSub`, `_primary` constants exist with exact hex values listed above. Same for `RushResultScreen`.
4. Grep `fontFamily: 'Fraunces'` in each of `survival_result_screen.dart` and `rush_result_screen.dart` returns ≥1 match; the containing `TextStyle` also declares `fontSize: 56` and `fontWeight: FontWeight.w900` within 20 lines.
5. Home `_StatCard` `build()` method contains a `Container` with `decoration` using `LinearGradient` (not `color`) for the icon background. `_ModeData.gradientColors.length == 2` for all 3 mode instances.
6. Home `_StatCard` contains **no** `AnimatedCrossFade` for the accent bar (grep confirms removal).
7. `SizedBox(height: 106)` in `_buildStatCards()` is replaced with `SizedBox(height: 130)`.
8. `DayBox` constructor signature matches: `required int rewardAmount, required String rewardKind`. No `String reward` parameter remains.
9. `day_box.dart` `build()` contains no occurrences of the literal characters `·` or `★`.
10. `day_box.dart` `build()` contains no `Text('D$dayNumber'` expression (grep).
11. The single `DayBox(...)` construction in `event_screen.dart` passes both `rewardAmount:` and `rewardKind:` named arguments; the `_rewards` const is a `List<({int amount, String kind})>` with 7 entries; no `'💎'` / `'📘'` / `'📗'` / `'🃏'` emoji characters remain in the `_rewards` list literal.
12. `flutter analyze` exits with "No issues found".
13. `flutter test` exits 0.

## Verification Plan

1. Run `flutter analyze` — expect zero issues.
2. Run `flutter test` — expect all tests pass. No test files are modified by this pass (none of the changed APIs are exercised in existing tests; `DayBox` has no direct widget test).
3. Manual device check: Home screen mode cards, Event tab 7-day streak panel, Survival result (after playing 1 round), Rush result (after playing 1 round). Compare against approved mockups in `.superpowers/brainstorm/polish-pass/`.
4. Grep checks per Acceptance Criteria 1–11.
