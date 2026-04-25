# Events Tab — Manga Page Redesign

**Status:** Draft
**Date:** 2026-04-19
**Scope:** Visual redesign of `lib/features/event/presentation/event_screen.dart` only. No state/persistence work. Game screens and bottom nav untouched.

---

## 1. Problem & Goal

The existing Events tab reuses the same `DeepNightBackground` cosmic theme as Home, so it reads as "another Home screen with different content". We want the Events tab to feel like a distinct, special space that signals "you stepped into something seasonal and exciting" — without touching the rest of the app.

The user's anchor idea: **manga page layout** — boxed panels with thick black borders on white paper. Even without characters, the panel language alone signals "anime/manga event".

---

## 2. Design Direction (Approved)

**V1 — Authentic White Manga, Grid Layout.**

- Paper background `#F5F2E8` with halftone dots: **1.0px diameter circles on 6px grid, 9% ink opacity** (locked values — do not vary)
- Ink `#0B0B0B` for all borders, text, and shadows
- Accent: `manga-red #E63946` for "live now" badges, today-claimable, and your-rank chip
- Medals: `gold #FFD93D`, `silver #C8CDD3`, `bronze #D98E4A`
- Typography:
  - **Bangers** — display & section titles
  - **Bebas Neue** — labels, XP numbers
  - **Inter** — body (keep existing)
- Panel language: 3px ink border + 3px offset drop shadow (no blur) → "pop out" comic feel
- Strategic rotation: top-bar title `-2°`, season badge `+1.5°`, section labels `-1°`. Panels themselves stay at 0° (grid discipline).

**Rejected alternatives:**
- V2 Dark Seinen Manga — too moody, loses "festive anime event" energy
- V3 Hybrid Cosmic Manga — best cohesion but dilutes "stepping into a different space" signal
- B Irregular Panel Layout — more theatrical but too busy for a tab users visit daily for login claims

---

## 3. Scope

### In scope
- `lib/features/event/presentation/event_screen.dart` — full rewrite
- New shared widgets: `MangaPanel`, `InkButton`, `StarburstBadge`, `PodiumSlot`, `MilestoneRow`, `DayBox`
- New background widget: `MangaPaperBackground` (used only inside `EventScreen`)
- Font asset additions to `pubspec.yaml`: Bangers, Bebas Neue (Google Fonts, bundled locally)
- Static mock data — same shape as existing screen (claim state, milestone list, leaderboard entries)

### Out of scope
- Any Riverpod notifier / state wiring / persistence (stays `setState` mock like today)
- Event game screens (Survival/Rush/Daily when launched from Events tab) — stay cosmic dark
- Bottom nav bar — stays dark (acts as consistent "frame" around the manga page)
- Event question pool / backend / new features beyond visual redesign

---

## 4. Screen Breakdown

### 4.1 Top Bar (persistent across all 3 tabs)
```
[EVENTS (-2°)]  [SEASON 1 (+1.5°)]              [★ 430 XP]
```
- `EVENTS` — Bangers 32px, ink, rotate -2°
- `SEASON 1` — ink bg, paper text, Bebas Neue 12px, 2px ink border, rotate +1.5°
- `★ 430 XP` — white bg, 2.5px ink border, 2px offset shadow, Bebas Neue 13px

### 4.2 Tab Selector
```
[  PLAY  ][REWARDS][  RANK  ]
```
- 3 equal-width chunky buttons
- Active: filled ink bg + paper text
- Inactive: white bg + ink text + 2px ink border + 2px offset shadow
- Bangers 13px
- `HapticFeedback.selectionClick()` on tap

### 4.3 Play Tab

**A. Featured event panel** (~140px tall)
- 3px ink border + 3px shadow, white bg
- Diagonal speed-lines overlay: `CustomPainter` draws parallel `drawLine` at -18°, 8px gap, 1px stroke, ink 6% opacity. `shouldRepaint => false`.
- `LIVE NOW!!` red badge — Bangers 13px, rotate -3°, 2px ink border, 2px shadow
- `JAPANESE ANIME` title — Bangers 30px, 2-line
- `1,000 exclusive questions` subtitle — Inter 11px, ink 70%
- 88×88 starburst badge bottom-right, red bg, ink border, centered `14 / DAYS LEFT` text
- **Note:** The existing screen's inline "Season XP" progress bar is intentionally dropped from this panel and moved to the Rewards tab (Section 4.4.A). Keeps featured panel focused on "what + when".

**B. Daily Login panel** (~110px tall)
- Header: `7-DAY STREAK` (Bangers 18px) left, `D4 · TAP TO CLAIM!` red Bebas Neue right
- 7 equal-width day boxes, 2px ink border each
  - Claimed: ink bg + paper text + ✓
  - Today (claimable): red bg + paper text + 🎁 + translated `(-1px, -1px)` with 2px shadow (pop)
  - Future: white bg + ink text + `·` placeholder
- Each box shows reward icon on top, `D1-D7` label bottom (Bebas Neue 8px)
- Tap on today box → `HapticFeedback.heavyImpact()` + styled SnackBar (ink bg, Bangers font, "Day 4 claimed! +1 BOOK 📘")

**C. Event Modes section**
- Section label `EVENT MODES` — Bangers 16px, rotate -1°
- 2-col grid, gap 8px:
  - **Classic** — `grid-column: span 2` (wide). Two explicit states:
    - **Claimable (not yet played today):** yellow gradient bg (`#FFF9DC → #FFE88F`), ink `PLAY!` button (rotate -2°), status text `+50 EVENT XP` (Bebas Neue, ink 70%)
    - **Done (played today):** white bg, green pill `DONE` (bg `#2A7D2A`, paper text, rotate 0°, no shadow), status text `DONE TODAY` (Bebas Neue, ink 70%)
    - Both states: ⚡ icon + Bangers 16px `CLASSIC` title, 3px ink border, 2px shadow
  - **Survival** / **Rush** / **Daily** — 1-col, white bg, single state (always claimable)
    - Mode icon + Bangers title (🔥 SURVIVAL, ⚡ RUSH, 🗓 DAILY)
    - XP label: `+80 XP/RUN`, `+60 XP/RUN`, `+40 XP · 1×/DAY`
- Each card: 3px ink border, 2px shadow, `PLAY!` button (ink bg, paper text, Bangers 11px, rotate -2°) bottom-right
- Tap → `HapticFeedback.mediumImpact()` + `context.go(route)`

### 4.4 Rewards Tab

**A. Season Pass panel**
- Label `SEASON PASS` Bangers 16px + `430 / 1000` Bebas Neue on right
- Progress track: 12px tall, 2px ink border. Fill uses `CustomPainter` that draws parallel diagonal `drawLine`s at 45°, 4px gap, 3px stroke, alternating ink + `#333`. Clipped to progress width.

**B. Milestone rows** (7 rows for Season 1 placeholder: 100/200/350/500/650/800/1000 XP)
- 3px ink border, 2px shadow, 56px height
- Left: 40×40 icon box with 2.5px ink border, emoji centered
- Middle: Bangers 15px label, optional progress hint below
- Right: `{xp} XP` Bebas Neue 11px chip (ink bg, paper text)
- States:
  - **Claimed** — `#EEEAD7` bg, label strikethrough 55% opacity, icon box filled ink + ✓
  - **Next** (first unclaimed) — border 4px instead of 3px, `#FFFDF0` bg, `86% · 70 XP to go` red hint below label, `SOON` red button (rotate -3°)
  - **Future** — normal white bg
- Final milestone (1000 XP RARE EVENT CARD) — add 👑 crown badge at top-right (rotate 18°), red xp chip instead of ink

### 4.5 Rank Tab

**A. Podium panel** (~230px tall, white bg, halftone diagonal overlay)
- Small `TOP 3 ★` label top-left (Bangers 14px, rotate -1°)
- SFX `WOW!!` top-right (Bangers 18px red with 1.5px ink stroke, rotate +8°)
- 3-col grid bottom-aligned, ratio `1 : 1.15 : 1` (center slightly wider):
  - **Slot 2** (left, silver) — 56×56 avatar, name, xp chip, 56px-tall silver block with `2` Bangers 30px + 🥈 medal badge (rotate +12°)
  - **Slot 1** (center, gold) — 👑 crown floating above, 66×66 avatar (larger), name, red xp chip, 74px-tall gold block with `1` + 🥇 badge
  - **Slot 3** (right, bronze) — 56×56 avatar, name, xp chip, 44px-tall bronze block with `3` + 🥉 badge
- Each block: 3px ink border, 3px shadow

**B. YOUR RANK chip**
- Red bg, 3px ink border, 3px shadow
- 🏆 + `YOUR RANK / #42` + `430 XP` right-aligned

**C. Other players list**
- Section label `OTHER PLAYERS` Bangers 15px rotate -1°
- Rows for ranks #4–#N: 3px ink border, 2px shadow, 44px height
- `#N` Bangers 15px, 28×28 avatar circle (2px border), name Inter 700 12px, xp chip ink/paper
- "You" row pinned at bottom: `#FFF0D4` bg, 4px ink border, same layout

**D. Edge case rules**
- **<3 players total:** render podium with placeholder slot(s) — avatar shows `?`, name shows `—`, xp chip shows `— XP`, block still appears with rank number but dimmed (50% opacity). Never hide the podium frame.
- **User is in top 3:** YOUR RANK chip still renders above podium (shows `#1 / #2 / #3` and user's xp). User's podium slot gets a 4px red border (instead of 3px ink) to highlight. "OTHER PLAYERS" list starts from #4 as usual; do NOT pin "You" row at bottom in this case.
- **Empty "Other Players" (only ≤3 total):** omit the `OTHER PLAYERS` label and section entirely. Show nothing between YOUR RANK chip and bottom padding.

---

## 5. Component Inventory

### New shared widgets (`lib/features/event/presentation/widgets/`)
| Widget | Purpose |
|---|---|
| `MangaPaperBackground` | CustomPainter: paper bg + halftone dots. Static, `shouldRepaint=false` |
| `MangaPanel` | 3px ink border + 3px offset shadow container. Accepts child, padding, optional `backgroundColor` |
| `InkButton` | Chunky button (ink bg, paper text, Bangers font, optional rotation) |
| `StarburstBadge` | Polygon clip-path badge (used for "14 DAYS LEFT" + medal callouts). Accepts color, label, sublabel |
| `DayBox` | Single day-of-streak box. Takes state: claimed / today / future |
| `MilestoneRow` | Rewards tab row. Takes state: claimed / next / future |
| `PodiumSlot` | One of 3 podium columns. Takes rank (1/2/3), avatar, name, xp |
| `LeaderboardRow` | Row for #4 and below. Takes entry + `isMe` |
| `SfxText` | Floating sound-effect text (Bangers + stroke + rotation) |

### Font additions
- Add `Bangers-Regular.ttf` + `BebasNeue-Regular.ttf` under `assets/fonts/`
- Declare in `pubspec.yaml` under `flutter.fonts`
- Both fonts are licensed under **SIL Open Font License 1.1** (confirmed on Google Fonts: Bangers by Vernon Adams, Bebas Neue by Dharma Type)
- **OFL 1.1 bundling requirement:** include `OFL.txt` license file in `assets/fonts/` alongside the .ttf files. Declare in `pubspec.yaml` assets list. This is a legal requirement, not optional.

### Design tokens (`lib/features/event/presentation/event_tokens.dart`)
```dart
const Color eventPaper = Color(0xFFF5F2E8);
const Color eventInk = Color(0xFF0B0B0B);
const Color eventRed = Color(0xFFE63946);
const Color eventGold = Color(0xFFFFD93D);
const Color eventSilver = Color(0xFFC8CDD3);
const Color eventBronze = Color(0xFFD98E4A);
// Not added to global AppColors — these are event-local.
```

---

## 6. Interactions & Haptics

Preserved from existing screen (match rest of app):
| Action | Haptic | Feedback |
|---|---|---|
| Tab switch | `selectionClick` | 200ms panel fade/slide |
| Tap event mode card | `mediumImpact` | Navigate to `/{mode}/game` |
| Claim daily login | `heavyImpact` | SnackBar (ink bg, Bangers font, paper text, "Day X claimed! +1 📘") |
| Future box tap | none | no-op |

No new animations beyond fade-in on tab switch (match existing `AnimatedCrossFade` pattern).

---

## 7. Implementation Notes

**File structure:**
```
lib/features/event/presentation/
  event_screen.dart              (rewritten)
  event_tokens.dart              (new — color constants)
  widgets/
    manga_paper_background.dart
    manga_panel.dart
    ink_button.dart
    starburst_badge.dart
    day_box.dart
    milestone_row.dart
    podium_slot.dart
    leaderboard_row.dart
    sfx_text.dart
```

**Performance:**
- `MangaPaperBackground` painter: `shouldRepaint => false`. Paper fill + halftone dots painted once.
- All rotations via `Transform.rotate` — cheap, no per-frame work.
- No animations beyond existing `AnimatedCrossFade` and `AnimatedContainer` patterns.

**Risk / watch-outs:**
- Font rendering: Bangers has tight letter-spacing; test on small devices that "LIVE NOW!!" doesn't clip.
- Halftone opacity locked at 9% (see Section 2) — do not increase or it shimmers on low-DPI.
- `StarburstBadge`: 12 spikes (24 vertices total — 12 outer + 12 inner) generated by polar-coordinate loop inside `CustomPainter.paint` (outer radius = size/2, inner radius = outer × 0.62). 20 vertices is too many at 88px and reads circular; 12 reads sharp. Implementation: ~15 lines.
- **No CSS primitives in Flutter:** every `repeating-linear-gradient` reference in mockups maps to `CustomPainter` + parallel `drawLine` calls in this spec. No `Image.asset` tiled SVGs needed.
- Bottom nav stays dark → last pixel of page content must have enough bottom padding so white area doesn't clash with dark nav. Use `SafeArea` + existing 80px bottom padding.
- **Dark mode override:** Events tab is the only screen in the app that uses a light background. The `MangaPaperBackground` and all ink colors are hardcoded — do NOT wire `Theme.of(context).brightness`. System dark mode does not affect Events tab.

**Testing:**
- Widget test: `EventScreen` renders with tabs + all 3 tab contents addressable.
- Golden test (optional): one snapshot per tab at 380×800.
- Manual: verify bottom nav dark → paper transition looks intentional, not broken.

---

## 8. Content (Season 1 placeholder)

Featured event: **Japanese Anime · 1,000 exclusive questions · 14 days left · 53% season XP**.

Daily login 7-day rewards:
- D1 50💎 · D2 1📘 · D3 100💎 · D4 1📘 · D5 200💎 · D6 2📗 · D7 🃏 Rare Event Card

Milestones (7): 100 → 50 crystals · 200 → Silver Book · 350 → 100 crystals · 500 → Event Book · 650 → Uncommon Card · 800 → 2 Event Books · 1000 → Rare Event Card 👑

Leaderboard placeholder data: identical to existing screen (AnimeMaster 1250 → StudyBuddy 480, You #42 at 430).

---

## 9. Accessibility

- **Contrast ratios** (paper `#F5F2E8` / ink `#0B0B0B` ≈ 17:1 AAA; manga-red `#E63946` on paper ≈ 4.6:1 — passes AA for text ≥18pt / 14pt bold only). Red is only used on large display text (Bangers ≥13px bold) and large surfaces (badges, chips) — never body text. OK.
- **Font scaling:** Bangers at 30px with 2× `textScaler` → 60px will overflow the 140px-tall featured panel. Use `MediaQuery(...textScaler: TextScaler.linear(math.min(scale, 1.3)))` wrapping Events tab only. Clamps scale to 1.3× max within this screen.
- **Semantic labels:** podium slots need `Semantics(label: 'Rank ${n}, ${name}, ${xp} XP')`. Day boxes need `Semantics(button: true, enabled: isClaimable, label: 'Day ${n}, ${state}, ${reward}')`.
- **Haptics already match app conventions** — no additional a11y work needed.

## 10. No-loading-state Policy

All data in this screen is synchronous `const` mock data. **No `FutureBuilder`, no loading spinners, no error states are required or allowed in this spec.** The `_claimedUpTo` and `_todayClaimed` fields stay in `StatefulWidget` as today. If a user double-taps the claim box faster than setState runs, the second tap is a no-op because `canClaim = !todayClaimed` is re-evaluated on rebuild.

## 11. Acceptance Criteria (falsifiable)

- [ ] Events tab Scaffold uses `MangaPaperBackground`; Widget Inspector shows no `DeepNightBackground` in the Events subtree
- [ ] All 3 tabs present; `TabController.length == 3`; each `IndexedStack` child builds without throwing
- [ ] Widget probe: top-bar "EVENTS" text has `style.fontFamily == 'Bangers'` (catches missing font registration fallback to Inter)
- [ ] Widget probe: "430 XP" has `style.fontFamily == 'BebasNeue'`
- [ ] Podium slot heights: gold block = 74px, silver = 56px, bronze = 44px (verify via `RenderBox.size.height`)
- [ ] Daily login claim: before tap `_todayClaimed == false`; after tap on day-4 box `_todayClaimed == true` AND `_claimedUpTo == 3`; SnackBar appears with text containing "Day 4"
- [ ] Classic card state logic: given `dailyClassicDone == true` → card bg is white + green `DONE` pill visible; `== false` → yellow gradient bg + `PLAY!` ink button visible
- [ ] Leaderboard edge cases: with `entries.length < 3`, podium renders with `?` placeholder slots (verify via finder); with user rank ≤ 3, bottom "You" row is absent
- [ ] Halftone dot layer: `CustomPaint` with correct painter type exists in widget tree; manual device check confirms dots visible but not distracting
- [ ] `flutter analyze` exits 0 with no new warnings
- [ ] `flutter test` passes existing + new widget tests (at least one test per tab)
- [ ] Bottom nav: take screenshot with Events tab open → nav bar pixels at `#06081F` cosmic bg (unchanged)
- [ ] Routes: tap Survival card → `GoRouter.location == '/survival/game'`; Rush → `/rush/game`; Daily → `/daily/select`
- [ ] `OFL.txt` present under `assets/fonts/` and declared in `pubspec.yaml` assets list
