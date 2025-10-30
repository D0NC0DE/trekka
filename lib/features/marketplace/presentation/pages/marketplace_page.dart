import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/features/marketplace/presentation/widgets/category_pills.dart';
import 'package:trekka/features/marketplace/presentation/widgets/marketplace_app_bar.dart';
import 'package:trekka/features/marketplace/presentation/widgets/post_product.dart';
import 'package:trekka/features/marketplace/presentation/widgets/product_card.dart';
import 'package:trekka/features/marketplace/presentation/widgets/search_bar.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  static const List<String> _categories = <String>[
    'All',
    'Furniture',
    'Vehicles',
    'Fashion',
    'Subscriptions',
    'Electronics',
    'Books',
    'Sports',
    'Toys',
    'Other',
  ];

  static final List<_MarketplaceProduct> _products = <_MarketplaceProduct>[
    _MarketplaceProduct(
      title: 'Ergonomic Desk Chair',
      price: '₦45,000',
      image: AppAssetImages.avatar4,
      location: 'Lekki, Lagos',
    ),
    _MarketplaceProduct(
      title: 'Used SUV in great condition',
      price: '₦6,500,000',
      image: AppAssetImages.avatar5,
      location: 'Ikeja, Lagos',
    ),
    _MarketplaceProduct(
      title: 'Smart TV 55" 4K UHD',
      price: '₦320,000',
      image: AppAssetImages.avatar6,
      location: 'Abuja',
    ),
    _MarketplaceProduct(
      title: 'Handmade Ankara Dress',
      price: '₦18,500',
      image: AppAssetImages.avatar7,
      location: 'Ibadan',
    ),
    _MarketplaceProduct(
      title:
          'PS5 with extra controller with extra controller really long title that should be truncated',
      price: '₦470,000',
      image: AppAssetImages.avatar8,
      location: 'Festac, Lagos',
    ),
    _MarketplaceProduct(
      title: 'Premium Sound Bar',
      price: '₦210,000',
      image: AppAssetImages.avatar9,
      location: 'Enugu',
    ),
  ];

  static const bool _isLoadingProducts = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.marketplaceBackground,
        body: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MarketplaceAppBar(),
                const SizedBox(height: AppSpacing.smLg),
                const PostProduct(),
                const SizedBox(height: AppSpacing.smLg),
                const MarketplaceSearchBar(),
                const SizedBox(height: AppSpacing.md),
                const CategoryPills(categories: _categories),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final double gridWidth = constraints.maxWidth;
                          const double crossSpacing = AppSpacing.smLg;
                          final double itemWidth =
                              (gridWidth - crossSpacing) / 2;
                          const double cardHeight = 240;
                          final double childAspectRatio =
                              itemWidth / cardHeight;

                          final bool showSkeleton =
                              _isLoadingProducts || _products.isEmpty;
                          final int itemCount = showSkeleton
                              ? 6
                              : _products.length;

                          return GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: crossSpacing,
                                  mainAxisSpacing: AppSpacing.smLg,
                                  childAspectRatio: childAspectRatio,
                                ),
                            itemCount: itemCount,
                            itemBuilder: (BuildContext context, int index) {
                              if (showSkeleton) {
                                return const ProductCard.skeleton();
                              }

                              final _MarketplaceProduct product =
                                  _products[index];
                              return ProductCard(
                                imageAsset: product.image,
                                title: product.title,
                                price: product.price,
                                location: product.location,
                              );
                            },
                          );
                        },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarketplaceProduct {
  const _MarketplaceProduct({
    required this.title,
    required this.price,
    required this.image,
    this.location,
  });

  final String title;
  final String price;
  final String image;
  final String? location;
}
