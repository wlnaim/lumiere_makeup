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

enum SortOption {
  recent('Más recientes'),
  alphabetical('Alfabético A-Z');

  final String label;
  const SortOption(this.label);
}

class _HomeScreenState extends State<HomeScreen> {
  SortOption _currentSort = SortOption.recent;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  List<Product> get _sortedProducts {
    // Filtrar por búsqueda
    List<Product> filteredProducts = _products;
    if (_searchQuery.isNotEmpty) {
      filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Ordenar productos filtrados
    final products = List<Product>.from(filteredProducts);
    if (_currentSort == SortOption.recent) {
      products.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else {
      products.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    return products;
  }

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

  void _deleteProduct(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar producto'),
          content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _products.removeWhere((product) => product.id == productId);
                  // También eliminar del carrito si existe
                  _cartItems.removeWhere((item) => item.product.id == productId);
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Ordenar por',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ...SortOption.values.map((option) => ListTile(
              leading: Icon(
                _currentSort == option ? Icons.check_circle : Icons.radio_button_unchecked,
                color: _currentSort == option ? const Color(0xFFC77D9A) : Colors.grey,
              ),
              title: Text(option.label),
              onTap: () {
                setState(() {
                  _currentSort = option;
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  @override  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override  Widget build(BuildContext context) {
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
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar productos...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
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
                  child: GestureDetector(
                    onTap: _showSortMenu,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F0F5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.tune, size: 16, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(_currentSort.label, style: const TextStyle(fontSize: 14)),
                          const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Product Grid
                Expanded(
                  child: _sortedProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No se encontraron productos',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (_searchQuery.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Intenta con otro nombre',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _sortedProducts.length,
                          itemBuilder: (context, index) {
                            final product = _sortedProducts[index];
                            return ProductCard(
                              product: product,
                              onAdd: () => _addToCart(product),
                              onDelete: () => _deleteProduct(product.id),
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
