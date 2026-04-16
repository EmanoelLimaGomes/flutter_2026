import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

enum Status { loading, success, error }

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;

  List<Product> products = [];
  List<Map<String, dynamic>> cart = []; // Mudado para suportar quantidade
  Status status = Status.loading;
  String errorMessage = "";

  ProductViewModel(this.repository);

  void addToCart(Product product, int quantity) {
    int index = cart.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      cart[index]['quantity'] += quantity;
    } else {
      cart.add({'product': product, 'quantity': quantity});
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    cart.removeWhere((item) => item['product'].id == product.id);
    notifyListeners();
  }

  bool isInCart(Product product) => cart.any((item) => item['product'].id == product.id);

  double get cartTotal => cart.fold(0.0, (sum, item) => sum + ((item['product'].price as num).toDouble() * (item['quantity'] as int)));
  
  int get cartCount => cart.fold(0, (sum, item) => sum + (item['quantity'] as int));

  void toggleCart(Product product, [int quantity = 1]) {
    if (isInCart(product)) {
      removeFromCart(product);
    } else {
      addToCart(product, quantity);
    }
  }

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

  Future<void> addProduct(Product product) async {
    try {
      await repository.createProduct(product);
      await fetchProducts();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await repository.updateProduct(product);
      await fetchProducts();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      await fetchProducts();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  void toggleFavorite(Product product) {
    product.favorite = !product.favorite;
    notifyListeners();
  }

  List<Product> get favoriteProducts => products.where((p) => p.favorite).toList();
}