import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductRemoteDataSource {
  final String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      throw Exception("Erro ao buscar produtos");
    }
  }

  Future<void> createProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Erro ao criar produto");
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${product.id}'),
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao atualizar produto");
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao deletar produto");
    }
  }
}