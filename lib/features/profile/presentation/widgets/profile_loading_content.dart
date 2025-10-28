import 'package:flutter/material.dart';

import 'package:trekka/core/widgets/loading/linear_loader.dart';

/// Loading state shown while profile data initializes.
class ProfileLoadingContent extends StatelessWidget {
  const ProfileLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      child: CenteredLinearLoader(
        width: 200,
        message: 'Loading profile...',
      ),
    );
  }
}
