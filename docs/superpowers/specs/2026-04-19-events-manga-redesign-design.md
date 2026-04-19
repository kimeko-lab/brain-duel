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

- Paper background `#F5F2E8` with subtle halftone dots (6px grid, 9% opacity)
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
- Diagonal speed-lines overlay (repeating-linear-gradient -18°, 6% opacity)
- `LIVE NOW!!` red badge — Bangers 13px, rotate -3°, 2px ink border, 2px shadow
- `JAPANESE ANIME` title — Bangers 30px, 2-line
- `1,000 exclusive questions` subtitle — Inter 11px, ink 70%
- 88×88 starburst badge (polygon clip-path) bottom-right, red bg, ink border, centered `14 / DAYS LEFT` text

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
  - **Classic** — `grid-column: span 2` (wide)
    - Yellow gradient bg (`#FFF9DC → #FFE88F`) when claimable
    - Green `DONE` pill + `DONE TODAY` status when played today
    - `+50 EVENT XP` Bebas Neue label
    - Icon ⚡ Bangers title
  - **Survival** / **Rush** / **Daily** — 1-col, white bg
    - Mode icon + Bangers title (🔥 SURVIVAL, ⚡ RUSH, 🗓 DAILY)
    - XP label: `+80 XP/RUN`, `+60 XP/RUN`, `+40 XP · 1×/DAY`
- Each card: 3px ink border, 2px shadow, `PLAY!` button (ink bg, paper text, Bangers 11px, rotate -2°) bottom-right
- Tap → `HapticFeedback.mediumImpact()` + `context.go(route)`

### 4.4 Rewards Tab

**A. Season Pass panel**
- Label `SEASON PASS` Bangers 16px + `430 / 1000` Bebas Neue on right
- Progress track: 12px tall, 2px ink border, fill = diagonal hatching pattern (`repeating-linear-gradient 45° ink + #333`)

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
- Download from Google Fonts (SIL Open Font License)

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
- Halftone dot pattern at `BackgroundImage`-style can shimmer on low-DPI screens; keep opacity at 9% max.
- `StarburstBadge` polygon clip-path in Flutter: use `CustomPainter` with `Path` + lineTo's (polygon has 20 vertices).
- Bottom nav stays dark → last pixel of page content must have enough bottom padding so white area doesn't clash with dark nav. Use `SafeArea` + existing 80px bottom padding.

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

## 9. Acceptance Criteria

- [ ] Events tab loads with paper background, ink borders, Bangers title
- [ ] All 3 tabs (Play / Rewards / Rank) present and switchable
- [ ] Podium displays top-3 with distinct heights (gold 74 / silver 56 / bronze 44) and medals
- [ ] Daily login claim flow works: tap today box → SnackBar + state advances
- [ ] `flutter analyze` clean
- [ ] Fonts render correctly on Android + iOS (Bangers + Bebas Neue bundled)
- [ ] Bottom nav stays dark while inside Events tab
- [ ] Event-mode card taps navigate to correct `/{mode}/game` routes unchanged
