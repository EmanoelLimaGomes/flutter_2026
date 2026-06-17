import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/product_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../domain/entities/product.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import 'product_detail_page.dart';

class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          ProductViewModel(ProductRepositoryImpl(ProductRemoteDataSource()))
            ..fetchProducts(),
      child: Consumer<ProductViewModel>(
        builder: (context, vm, _) => Scaffold(
          key: _scaffoldKey,
          drawer: _buildMenuDrawer(context, vm), // Menu Geral
          endDrawer: _buildCartDrawer(context, vm), // Sacola na Direita
          appBar: AppBar(
            title: const Text('Manel Store'),
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 28),
                    if (vm.cart.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF8B1D33),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${vm.cartCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: _buildBody(context, vm),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showProductDialog(context, vm),
            backgroundColor: const Color(0xFF1D1D1F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuDrawer(BuildContext context, ProductViewModel vm) {
    double width = MediaQuery.of(context).size.width;
    bool isPC = width > 700;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      width: isPC ? width / 4 : width * 0.85,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manel Store',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF8B1D33),
                        child: Text(
                          user?.firstName?.isNotEmpty == true
                              ? user!.firstName![0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.fullName ?? 'Usuário',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (user?.email != null)
                              Text(
                                user!.email!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B1D33).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFF8B1D33),
                  size: 20,
                ),
              ),
              title: const Text(
                'Favoritos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Seus produtos salvos'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => _buildFavoritesDialog(context, vm),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
              title: const Text(
                'Meus Pedidos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Histórico de compras'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Em breve!')));
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
              title: const Text(
                'Sair',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              subtitle: const Text('Encerrar sessão'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () async {
                Navigator.pop(context);
                await authViewModel.logout();
              },
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'v1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesDialog(BuildContext context, ProductViewModel vm) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: width > 1000 ? width * 0.3 : 20,
        vertical: 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favoritos',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListenableBuilder(
                listenable: vm,
                builder: (context, _) => vm.favoriteProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum favorito ainda',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: vm.favoriteProducts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final p = vm.favoriteProducts[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.network(
                                p.image ?? '',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              p.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            subtitle: Text('R\$ ${p.price.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: Color(0xFF8B1D33),
                              ),
                              onPressed: () => vm.toggleFavorite(p),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartDrawer(BuildContext context, ProductViewModel vm) {
    double width = MediaQuery.of(context).size.width;
    bool isPC = width > 700;
    return Drawer(
      backgroundColor: Colors.white,
      width: isPC ? width / 4 : width * 0.85,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Minha Sacola',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: vm.cart.isEmpty
                    ? const Center(
                        child: Text(
                          'Sua sacola está vazia',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: vm.cart.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = vm.cart[index];
                          final p = item['product'] as Product;
                          final qty = item['quantity'] as int;
                          return Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.network(
                                  p.image ?? '',
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 40,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '${qty}x R\$ ${p.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => vm.removeFromCart(p),
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (vm.cart.isNotEmpty) ...[
                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    Text(
                      'R\$ ${vm.cartTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D1D1F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('FINALIZAR COMPRA'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductViewModel vm) {
    if (vm.status == Status.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.status == Status.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(vm.errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: vm.fetchProducts,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.products.isEmpty) {
      return const Center(child: Text('Nenhum produto disponível.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Grid flexível e moderno
        double width = constraints.maxWidth;
        int crossAxisCount = width > 1200
            ? 4
            : (width > 800 ? 3 : (width > 500 ? 2 : 1));

        return GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.65, // Aumentado para caber o seletor
          ),
          itemCount: vm.products.length,
          itemBuilder: (context, index) =>
              ProductCard(product: vm.products[index], viewModel: vm),
        );
      },
    );
  }

  void _showProductDialog(
    BuildContext context,
    ProductViewModel vm, [
    Product? product,
  ]) {
    final titleController = TextEditingController(text: product?.title ?? '');
    final priceController = TextEditingController(
      text: product?.price.toString() ?? '',
    );
    final imageController = TextEditingController(
      text: product?.image ?? 'https://i.pravatar.cc/150?u=fake',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Novo Produto' : 'Editar Produto'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                id: product?.id,
                title: titleController.text,
                price: double.tryParse(priceController.text) ?? 0,
                image: imageController.text,
              );
              if (product == null) {
                vm.addProduct(newProduct);
              } else {
                vm.updateProduct(newProduct);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1D1D1F),
              foregroundColor: Colors.white,
            ),
            child: const Text('SALVAR'),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final ProductViewModel viewModel;

  const ProductCard({
    super.key,
    required this.product,
    required this.viewModel,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final vm = widget.viewModel;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailPage(product: p, viewModel: vm),
              ),
            );
          },
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: 'product_image_${p.id}',
                          child: Image.network(
                            p.image ?? '',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(
                            p.favorite ? Icons.favorite : Icons.favorite_border,
                            color: p.favorite
                                ? const Color(0xFF8B1D33)
                                : Colors.black26,
                          ),
                          onPressed: () => vm.toggleFavorite(p),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  p.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Preço',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                        Text(
                          'R\$ ${p.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (!vm.isInCart(p))
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () => setState(() {
                                if (quantity > 1) quantity--;
                              }),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(4),
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => setState(() => quantity++),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (vm.isInCart(p)) {
                        vm.removeFromCart(p);
                      } else {
                        vm.addToCart(p, quantity);
                        setState(
                          () => quantity = 1,
                        ); // Reset quantity after adding
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: vm.isInCart(p)
                          ? const Color(0xFF8B1D33)
                          : const Color(0xFF1D1D1F),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          vm.isInCart(p)
                              ? Icons.shopping_bag
                              : Icons.add_shopping_cart,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          vm.isInCart(p) ? 'REMOVER' : 'ADICIONAR',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
