import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

const String _placeholderBackgroundAsset = 'assets/images/home-bg.png';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundAlt,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_placeholderBackgroundAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            'Placeholder Screen',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.deepTeal,
                ),
          ),
        ),
      ),
    );
  }
}
