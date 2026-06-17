import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    super.id,
    required super.title,
    required super.price,
    super.image,
    super.images,
    super.description,
    super.category,
    super.favorite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List?)?.map((e) => e.toString()).toList();
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['thumbnail'] ?? (imagesList?.isNotEmpty == true ? imagesList![0] : ''),
      images: imagesList,
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': image,
      'images': images,
      'description': description,
      'category': category,
    };
  }
}