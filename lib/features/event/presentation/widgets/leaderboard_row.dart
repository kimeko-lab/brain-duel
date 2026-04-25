import 'package:flutter/material.dart';

import '../event_tokens.dart';
import 'manga_panel.dart';

class LbEntry {
  const LbEntry({
    required this.rank,
    required this.name,
    required this.xp,
    this.isMe = false,
  });

  final int rank;
  final String name;
  final int xp;
  final bool isMe;
}

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({super.key, required this.entry});

  final LbEntry entry;

  @override
  Widget build(BuildContext context) {
    final bg = entry.isMe ? EventTokens.meYellow : Colors.white;
    final borderWidth = entry.isMe ? 4.0 : 3.0;

    return MangaPanel(
      backgroundColor: bg,
      borderWidth: borderWidth,
      shadowOffset: 2,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Semantics(
        label:
            'Rank ${entry.rank}, ${entry.name}, ${entry.xp} XP${entry.isMe ? ', you' : ''}',
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                '#${entry.rank}',
                textAlign: TextAlign.center,
                style: EventTokens.bangers(
                  size: 15,
                  color: EventTokens.ink,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFF0ECDD),
                border: Border.all(color: EventTokens.ink, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                entry.isMe ? '😎' : '👤',
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: EventTokens.inter(
                  size: 12,
                  weight: FontWeight.w700,
                  color: EventTokens.ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: const BoxDecoration(color: EventTokens.ink),
              child: Text(
                '${entry.xp} XP',
                style: EventTokens.bebas(
                  size: 11,
                  color: EventTokens.paper,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
