class Product {
  final int? id;
  final String title;
  final double price;
  final String image;
  final String? description;
  final String? category;
  bool favorite;

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.image,
    this.description,
    this.category,
    this.favorite = false,
  });
}