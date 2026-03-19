import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

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
}