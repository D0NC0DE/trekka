import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:trekka/core/assets/app_assets.dart';
import 'package:trekka/core/design/tokens.dart';
import 'package:trekka/core/router/route_paths.dart';
import 'package:trekka/features/marketplace/domain/entities/marketplace_product.dart';
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

  static const MarketplaceProduct _placeholderProduct = MarketplaceProduct(
    title: 'Loading Product',
    price: '0 ℏ',
    coverImage: '',
  );

  static final List<MarketplaceProduct> _products = <MarketplaceProduct>[
    MarketplaceProduct(
      title: 'Ergonomic Desk Chair - extremely long title that should be truncated',
      price: '45,000 ℏ',
      coverImage: AppAssetImages.avatar4,
      location: 'Lekki, Lagos',
      images: <String>[
        AppAssetImages.avatar4,
        AppAssetImages.avatar5,
        AppAssetImages.avatar6,
        AppAssetImages.avatar7,
      ],
      description:
          'Comfort meets style with this ergonomic desk chair. Adjustable height, breathable mesh, and lumbar support make it perfect for long work sessions.',
    ),
    MarketplaceProduct(
      title: 'Used SUV in great condition',
      price: '6,500,000 ℏ',
      coverImage: AppAssetImages.avatar5,
      location: 'Ikeja, Lagos',
      images: <String>[
        AppAssetImages.avatar5,
        AppAssetImages.avatar6,
        AppAssetImages.avatar7,
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
      description:
          'Play the latest titles in 4K with this lightly used PlayStation 5 bundle. Includes one extra DualSense controller and original packaging.',
    ),
    MarketplaceProduct(
      title: 'Premium Sound Bar',
      price: '210,000 ℏ',
      coverImage: AppAssetImages.avatar9,
      location: 'Enugu',
      images: <String>[AppAssetImages.avatar9, AppAssetImages.avatar6],
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MarketplaceAppBar(),
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
                                return const ProductCard(
                                  product: _placeholderProduct,
                                  isLoading: true,
                                );
                              }

                              final MarketplaceProduct product =
                                  _products[index];
                              return ProductCard(
                                product: product,
                                onTap: () => context.push(
                                  RoutePaths.marketplaceProductDetail,
                                  extra: product,
                                ),
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
