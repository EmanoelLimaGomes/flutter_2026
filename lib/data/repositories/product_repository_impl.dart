import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource datasource;

  List<Product>? cache;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final products = await datasource.getProducts();
      cache = products;
      return products;
    } catch (e) {
      if (cache != null) {
        return cache!;
      } else {
        throw Exception("Erro e sem cache disponível");
      }
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    final model = ProductModel(
      title: product.title,
      price: product.price,
      image: product.image,
    );
    await datasource.createProduct(model);
    cache = null; // Invalidate cache
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
    );
    await datasource.updateProduct(model);
    cache = null; // Invalidate cache
  }

  @override
  Future<void> deleteProduct(int id) async {
    await datasource.deleteProduct(id);
    cache = null; // Invalidate cache
  }
}