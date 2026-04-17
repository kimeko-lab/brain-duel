import 'dart:async';

import 'package:flutter/material.dart';

/// Full-width progress bar + time label countdown.
///
/// Counts down from 10.0 → 0.0 s and calls [onExpired] when it hits 0.
/// Pauses automatically when [isActive] is false (showingFeedback phase).
/// Resets when recreated with a new key (i.e. new question begins).
class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.onExpired,
    required this.isActive,
  });

  final VoidCallback onExpired;
  final bool isActive;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  static const double _startSeconds = 10.0;
  static const int    _tickMs       = 100;

  double _remaining = _startSeconds;
  Timer? _timer;
  bool   _expired  = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isActive) _startTimer();
    });
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive)  _startTimer();
    if ( oldWidget.isActive && !widget.isActive) _pauseTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: _tickMs),
      _onTick,
    );
  }

  void _pauseTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTick(Timer timer) {
    if (!mounted) { timer.cancel(); return; }
    setState(() {
      _remaining -= _tickMs / 1000.0;
      if (_remaining <= 0) {
        _remaining = 0;
        timer.cancel();
        _timer = null;
        if (!_expired) {
          _expired = true;
          widget.onExpired();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Colors ─────────────────────────────────────────────────────────────────

  Color get _barColor {
    if (_remaining > 5.0) return const Color(0xFF00D084); // green
    if (_remaining > 3.0) return const Color(0xFFFACC15); // yellow
    return const Color(0xFFFF6B6B);                        // red
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / _startSeconds;

    return Row(
      children: [
        // Progress bar — fills available width
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Time label — fixed width prevents layout shift
        SizedBox(
          width: 38,
          child: Text(
            '${_remaining.toStringAsFixed(1)}s',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _barColor,
              height: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
