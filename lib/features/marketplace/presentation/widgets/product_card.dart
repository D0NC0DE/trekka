import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.imageAsset,
    required this.title,
    required this.price,
    this.location,
    super.key,
  });

  final String imageAsset;
  final String title;
  final String price;
  final String? location;

  static const double _cardRadius = AppRadius.sm; // 8px

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Color(0x40FFFFFF), Color(0x40EDFFFD)],
          ),
          borderRadius: BorderRadius.circular(_cardRadius),
          border: const Border(
            bottom: BorderSide(
              color: AppColors.marketplaceCardBorder,
              width: 1,
            ),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 170,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(_cardRadius),
                  topRight: Radius.circular(_cardRadius),
                ),
                child: Image.asset(
                  imageAsset,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.black,
                      fontWeight: AppFontWeights.medium,
                      height: 1.0,
                      fontSize: AppSpacing.smLg,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    price,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
