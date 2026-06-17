class Product {
  final int? id;
  final String title;
  final double price;
  final String? image;
  final List<String>? images;
  final String? description;
  final String? category;
  bool favorite;

  Product({
    this.id,
    required this.title,
    required this.price,
    this.image,
    this.images,
    this.description,
    this.category,
    this.favorite = false,
  });
}