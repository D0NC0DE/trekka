import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: Center(
        child: Text(
          'Placeholder Screen',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.deepTeal,
              ),
        ),
      ),
    );
  }
}
