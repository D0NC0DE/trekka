import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/router/route_paths.dart';
import 'package:trekka/features/marketplace/domain/entities/marketplace_product.dart';
import 'package:trekka/features/marketplace/presentation/widgets/details/image_carousel.dart';
import 'package:trekka/features/marketplace/presentation/widgets/details/product_detail_card.dart';
import 'package:trekka/features/marketplace/presentation/widgets/marketplace_app_bar.dart';
import 'package:trekka/features/marketplace/presentation/widgets/product_card.dart';

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

  static const List<MarketplaceProduct> _similarProducts = <MarketplaceProduct>[
    MarketplaceProduct(
      title: 'Ergonomic Desk Chair',
      price: '45,000 ℏ',
      coverImage: AppAssetImages.avatar4,
      location: 'Lekki, Lagos',
      images: <String>[
        AppAssetImages.avatar4,
        AppAssetImages.avatar5,
        AppAssetImages.avatar6,
      ],
    ),
    MarketplaceProduct(
      title: 'Smart TV 55" 4K UHD',
      price: '320,000 ℏ',
      coverImage: AppAssetImages.avatar6,
      location: 'Abuja',
      images: <String>[AppAssetImages.avatar6, AppAssetImages.avatar9],
    ),
    MarketplaceProduct(
      title: 'Handmade Ankara Dress',
      price: '18,500 ℏ',
      coverImage: AppAssetImages.avatar7,
      location: 'Ibadan',
      images: <String>[AppAssetImages.avatar7, AppAssetImages.avatar4],
    ),
    MarketplaceProduct(
      title: 'PS5 with extra controller',
      price: '470,000 ℏ',
      coverImage: AppAssetImages.avatar8,
      location: 'Festac, Lagos',
      images: <String>[AppAssetImages.avatar8, AppAssetImages.avatar5],
    ),
  ];

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
    final List<MarketplaceProduct> similarProducts = _similarProducts
        .where((MarketplaceProduct product) =>
            product.heroTag != widget.product.heroTag)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.marketplaceBackground,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MarketplaceAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ProductHeroImage(
                        imagePath: selectedImage,
                        heroTag: widget.product.heroTag,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ImageCarousel(
                        images: _gallery,
                        selectedIndex: _selectedIndex,
                        onSelect: _handleSelect,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ProductDetailCard(widget: widget),
                      const SizedBox(height: AppSpacing.xl),
                      if (similarProducts.isNotEmpty) ...[
                        Text(
                          'Check similar items',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: AppFontWeights.semiBold,
                              ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        SizedBox(
                          height: 240,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: similarProducts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: AppSpacing.smLg),
                            itemBuilder: (BuildContext context, int index) {
                              final MarketplaceProduct product =
                                  similarProducts[index];
                              return SizedBox(
                                width: 180,
                                child: ProductCard(
                                  product: product,
                                  onTap: () => context.push(
                                    RoutePaths.marketplaceProductDetail,
                                    extra: product,
                                  ),
                                ),
                              );
                            },
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
  const _ProductHeroImage({required this.imagePath, required this.heroTag});

  final String imagePath;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final Widget image = ClipRRect(
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

    if (heroTag.isEmpty || imagePath.isEmpty) {
      return image;
    }

    return Hero(tag: heroTag, child: image);
  }
}
