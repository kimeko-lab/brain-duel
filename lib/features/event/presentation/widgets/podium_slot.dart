import 'package:flutter/material.dart';

import '../event_tokens.dart';

class PodiumSlot extends StatelessWidget {
  const PodiumSlot({
    super.key,
    required this.rank, // 1, 2, or 3
    required this.name,
    required this.xp,
    required this.isMe,
    required this.isPlaceholder,
  });

  final int rank;
  final String name;
  final int xp;
  final bool isMe;
  final bool isPlaceholder;

  Color get _color {
    switch (rank) {
      case 1:
        return EventTokens.gold;
      case 2:
        return EventTokens.silver;
      case 3:
        return EventTokens.bronze;
      default:
        return Colors.white;
    }
  }

  double get _blockHeight {
    switch (rank) {
      case 1:
        return 74;
      case 2:
        return 56;
      case 3:
        return 44;
      default:
        return 40;
    }
  }

  double get _avatarSize => rank == 1 ? 66 : 56;

  String get _medal {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarFg = rank == 3 ? Colors.white : EventTokens.ink;
    final opacity = isPlaceholder ? 0.5 : 1.0;
    final highlightBorder = isMe && !isPlaceholder
        ? EventTokens.red
        : EventTokens.ink;
    final highlightWidth = isMe && !isPlaceholder ? 4.0 : 3.0;

    final avatarContent = isPlaceholder
        ? Text('?',
            style: EventTokens.bangers(
                size: _avatarSize * 0.42, color: EventTokens.ink))
        : rank == 1
            ? const Text('👑', style: TextStyle(fontSize: 30))
            : Text('👤', style: TextStyle(fontSize: 22, color: avatarFg));

    return Opacity(
      opacity: opacity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar (with optional crown floating above for rank 1)
          SizedBox(
            height: _avatarSize + (rank == 1 ? 14 : 0),
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: _avatarSize,
                  height: _avatarSize,
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                    border: Border.all(color: highlightBorder, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: EventTokens.ink,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: avatarContent,
                ),
                if (rank == 1 && !isPlaceholder)
                  Positioned(
                    top: -14,
                    child: Transform.rotate(
                      angle: -4 * 3.1415926535 / 180,
                      child: const Text('👑',
                          style: TextStyle(fontSize: 24)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Name
          Text(
            isPlaceholder ? '—' : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: EventTokens.inter(
              size: 11,
              weight: FontWeight.w800,
              color: EventTokens.ink,
            ),
          ),
          const SizedBox(height: 2),
          // XP chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: (rank == 1 && !isPlaceholder)
                  ? EventTokens.red
                  : EventTokens.ink,
            ),
            child: Text(
              isPlaceholder ? '— XP' : '$xp XP',
              style: EventTokens.bebas(
                size: 10,
                color: EventTokens.paper,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Block
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                height: _blockHeight,
                decoration: BoxDecoration(
                  color: _color,
                  border:
                      Border.all(color: highlightBorder, width: highlightWidth),
                  boxShadow: const [
                    BoxShadow(
                      color: EventTokens.ink,
                      offset: Offset(3, 3),
                      blurRadius: 0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '$rank',
                  style: EventTokens.bangers(
                    size: 30,
                    color: rank == 3 ? Colors.white : EventTokens.ink,
                  ),
                ),
              ),
              if (!isPlaceholder)
                Positioned(
                  right: -6,
                  top: -8,
                  child: Transform.rotate(
                    angle: 12 * 3.1415926535 / 180,
                    child: Text(_medal,
                        style: const TextStyle(fontSize: 20)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
