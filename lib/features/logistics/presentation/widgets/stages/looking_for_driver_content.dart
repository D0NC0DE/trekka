import 'dart:async';

import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/button/gradient_action_button.dart';

class LookingForDriverContent extends StatefulWidget {
  const LookingForDriverContent({required this.onCancel, super.key});

  final VoidCallback onCancel;

  @override
  State<LookingForDriverContent> createState() =>
      _LookingForDriverContentState();
}

class _LookingForDriverContentState extends State<LookingForDriverContent>
    with SingleTickerProviderStateMixin {
  static const int _maxDots = 3;
  static const Duration _tick = Duration(milliseconds: 500);

  late Timer _timer;
  int _currentDots = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_tick, (_) {
      setState(() {
        _currentDots = (_currentDots + 1) % (_maxDots + 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dots = '.' * _currentDots;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Looking for a ride nearby$dots',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.white,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        GradientActionButton(label: 'Cancel ride', onTap: widget.onCancel),
      ],
    );
  }
}
