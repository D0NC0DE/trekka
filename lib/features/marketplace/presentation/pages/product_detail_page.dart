import 'package:flutter/material.dart';

import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/marketplace/domain/entities/marketplace_product.dart';
import 'package:trekka/features/marketplace/presentation/widgets/details/image_carousel.dart';
import 'package:trekka/features/marketplace/presentation/widgets/marketplace_app_bar.dart';

class MarketplaceProductDetailPage extends StatefulWidget {
  const MarketplaceProductDetailPage({required this.product, super.key});

  final MarketplaceProduct product;

  @override
  State<MarketplaceProductDetailPage> createState() =>
      _MarketplaceProductDetailPageState();
}

class _MarketplaceProductDetailPageState
    extends State<MarketplaceProductDetailPage> {
  late int _selectedIndex;

  List<String> get _gallery => widget.product.gallery;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
  }

  void _handleSelect(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final String selectedImage = _gallery[_selectedIndex];

    return Scaffold(
      backgroundColor: AppColors.marketplaceBackground,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MarketplaceAppBar(),
              const SizedBox(height: AppSpacing.lg),
              _ProductHeroImage(imagePath: selectedImage),
              const SizedBox(height: AppSpacing.md),
              ImageCarousel(
                images: _gallery,
                selectedIndex: _selectedIndex,
                onSelect: _handleSelect,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.product.price,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppFontWeights.bold,
                        ),
                      ),
                      if (widget.product.location != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              size: 18,
                              color: AppColors.textPrimary50,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                widget.product.location!,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: AppColors.textPrimary50),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (widget.product.description != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.product.description!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductHeroImage extends StatelessWidget {
  const _ProductHeroImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.smMd),
      child: Container(
        height: 400,
        width: double.infinity,
        color: AppColors.logisticsActionInactive,
        child: imagePath.isEmpty
            ? const SizedBox.shrink()
            : Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
