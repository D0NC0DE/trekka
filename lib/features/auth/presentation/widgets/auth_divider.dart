import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(child: _DividerLine(color: AppColors.white40)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'or',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(child: _DividerLine(color: AppColors.white40)),
      ],
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: color, width: 1)),
      ),
    );
  }
}

