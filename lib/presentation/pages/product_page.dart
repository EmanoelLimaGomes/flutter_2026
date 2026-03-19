import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/product_viewmodel.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(
        ProductRepositoryImpl(ProductRemoteDataSource()),
      )..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Produtos')),
        body: Consumer<ProductViewModel>(
          builder: (context, vm, _) {
            if (vm.status == Status.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.status == Status.error) {
              return Center(child: Text(vm.errorMessage));
            }

            return ListView.builder(
              itemCount: vm.products.length,
              itemBuilder: (_, index) {
                final p = vm.products[index];

                return ListTile(
                  leading: Image.network(p.image, width: 50),
                  title: Text(p.title),
                  subtitle: Text("R\$ ${p.price}"),
                );
              },
            );
          },
        ),
      ),
    );
  }
}