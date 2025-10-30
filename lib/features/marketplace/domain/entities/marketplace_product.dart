class MarketplaceProduct {
  const MarketplaceProduct({
    required this.title,
    required this.price,
    required this.coverImage,
    this.location,
    this.images = const <String>[],
    this.description,
  });

  final String title;
  final String price;
  final String coverImage;
  final String? location;
  final List<String> images;
  final String? description;

  List<String> get gallery => images.isNotEmpty ? images : <String>[coverImage];
}
