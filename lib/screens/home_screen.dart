import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_bottom_bar.dart';
import 'add_product_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'labial x',
      price: 25.31,
      imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc4033c8?q=80&w=800&auto=format&fit=crop',
      timestamp: DateTime.now(),
    ),
    Product(
      id: '2',
      name: 'Velvet Matte Lipstick',
      price: 24.50,
      imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=800&auto=format&fit=crop',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    Product(
      id: '3',
      name: 'Perfume Noir',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601?q=80&w=800&auto=format&fit=crop',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Product(
      id: '4',
      name: 'Skincare Duo',
      price: 32.00,
      imageUrl: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=800&auto=format&fit=crop',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  final List<CartItem> _cartItems = [];

  int get _cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get _cartTotal => _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _addToCart(Product product) {
    setState(() {
      // Buscar si el producto ya está en el carrito
      final existingIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
      
      if (existingIndex >= 0) {
        // Si ya existe, incrementar cantidad
        _cartItems[existingIndex].quantity++;
      } else {
        // Si no existe, agregarlo
        _cartItems.add(CartItem(product: product));
      }
    });
  }

  Future<void> _openCartScreen() async {
    final result = await Navigator.push<List<CartItem>>(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: _cartItems),
      ),
    );

    if (result != null) {
      setState(() {
        _cartItems.clear();
        _cartItems.addAll(result);
      });
    }
  }

  Future<void> _openAddProductScreen() async {
    final result = await showDialog<Product>(
      context: context,
      builder: (context) => const AddProductScreen(),
    );

    if (result != null) {
      setState(() {
        _products.insert(0, result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumière'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _openAddProductScreen,
              icon: const Icon(Icons.add, color: Color(0xFFC77D9A)),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFFF8F0F5).withOpacity(0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter Button
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F0F5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune, size: 16, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Más recientes', style: TextStyle(fontSize: 14)),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Product Grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: _products[index],
                        onAdd: () => _addToCart(_products[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_cartCount > 0)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: CartBottomBar(
                count: _cartCount,
                total: _cartTotal,
                onTap: _openCartScreen,
              ),
            ),
        ],
      ),
    );
  }
}
