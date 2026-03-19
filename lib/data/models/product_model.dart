import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String title,
    required double price,
    required String image,
  }) : super(title: title, price: price, image: image);

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
    );
  }
}