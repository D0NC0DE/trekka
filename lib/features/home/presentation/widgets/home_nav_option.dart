import 'package:flutter/material.dart';

import 'package:trekka/core/design/shadows.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/widgets/inner_shadow.dart';

class HomeNavOption extends StatelessWidget {
  const HomeNavOption({
    super.key,
    this.icon,
    this.assetPath,
    required this.label,
    this.isActive = false,
  });

  final IconData? icon;
  final String? assetPath;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(66);
    final List<BoxShadow> inner = AppShadows.homeNavOptionInner;
    final Color borderColor = AppColors.deepTeal;
    final Color activeBg = AppColors.primary;

    Widget buildIcon() {
      if (assetPath != null) {
        return Image.asset(assetPath!, width: 50, height: 52);
      }
      return Icon(icon, size: 28);
    }

    if (isActive) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 128),
        child: SizedBox(
          height: 60,
          child: InnerShadow(
            borderRadius: radius,
            shadows: inner,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: activeBg,
                borderRadius: radius,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 50, height: 52, child: buildIcon()),
                    const SizedBox(width: 6),
                    Text(
                      label.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accentAmber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 60,
      height: 60,
      child: InnerShadow(
        borderRadius: radius,
        shadows: inner,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Center(
            child: SizedBox(width: 50, height: 52, child: buildIcon()),
          ),
        ),
      ),
    );
  }
}
