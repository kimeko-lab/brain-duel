import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Counts down from 10.0 to 0.0 seconds and calls [onExpired] when it hits 0.
///
/// Pauses automatically when [isActive] is false (e.g. during showingFeedback).
/// Resets when the widget is recreated (i.e. when a new question begins).
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
  static const int _tickMs = 100;

  double _remaining = _startSeconds;
  Timer? _timer;
  bool _expired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.isActive) {
        _startTimer();
      }
    });
  }

  @override
  void didUpdateWidget(CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      _startTimer();
    } else if (oldWidget.isActive && !widget.isActive) {
      _pauseTimer();
    }
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
    if (!mounted) {
      timer.cancel();
      return;
    }
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

  Color get _timerColor {
    if (_remaining > 3.0) return AppColors.correct;
    if (_remaining >= 1.0) return AppColors.warning;
    return AppColors.wrong;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_remaining.toStringAsFixed(1)}s',
      style: AppTypography.headlineMedium.copyWith(
        color: _timerColor,
        shadows: [
          Shadow(
            color: _timerColor.withValues(alpha: 0.5),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}
