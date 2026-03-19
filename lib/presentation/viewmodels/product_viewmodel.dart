import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

enum Status { loading, success, error }

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;

  List<Product> products = [];
  Status status = Status.loading;
  String errorMessage = "";

  ProductViewModel(this.repository);

  Future<void> fetchProducts() async {
    status = Status.loading;
    notifyListeners();

    try {
      products = await repository.getProducts();
      status = Status.success;
    } catch (e) {
      status = Status.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}