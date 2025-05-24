import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = 'https://api-zqbymuqula-uc.a.run.app/products';
const String apiKey = 'ajsdi92ijwokldalksjd29ok2.aasd2';

class ProductSection extends StatefulWidget {
  const ProductSection({super.key});

  @override
  State<ProductSection> createState() => _ProductSectionState();
}

class _ProductSectionState extends State<ProductSection> with SingleTickerProviderStateMixin {
  static List? _cachedProducts;
  static Map<String, List>? _cachedProductsByCategory;
  static List<String>? _cachedCategories;
  static DateTime? _lastFetch;
  static const Duration cacheDuration = Duration(days: 7); // 1 semana

  bool loading = true;
  String? error;
  List products = [];
  Map<String, List> productsByCategory = {};
  List<String> categories = [];
  int selectedCategoryIndex = 0;
  List<bool> visibleItems = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCategory(int index) {
    if (!_scrollController.hasClients) return;

    // Calcular la posición aproximada del item
    final itemWidth = 200.0; // Ancho aproximado de cada item incluyendo el padding
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = (itemWidth * index) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final now = DateTime.now();
    if (_cachedProducts != null &&
        _cachedProductsByCategory != null &&
        _cachedCategories != null &&
        _lastFetch != null &&
        now.difference(_lastFetch!) < cacheDuration) {
      setState(() {
        products = _cachedProducts!;
        productsByCategory = _cachedProductsByCategory!;
        categories = _cachedCategories!;
        selectedCategoryIndex = 0;
        loading = false;
      });
      final selectedCategory = categories.isNotEmpty ? categories[0] : null;
      final productsList = selectedCategory != null ? productsByCategory[selectedCategory] ?? [] : [];
      visibleItems = List.generate(productsList.length, (_) => false);
      _runAppearAnimation(productsList.length);
    } else {
      fetchProducts();
    }
  }

  Future<void> fetchProducts() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {'x-api-key': apiKey});
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        // Filtrar productos con stock > 0
        products = data.where((p) => (p['stock'] ?? 0) > 0).toList();
        productsByCategory = {};
        for (var product in products) {
          final category = (product['category'] ?? 'Varios').toString().trim();
          productsByCategory.putIfAbsent(category, () => []).add(product);
        }
        categories = productsByCategory.keys.toList();
        selectedCategoryIndex = 0;
        loading = false;
        // Cachear
        _cachedProducts = products;
        _cachedProductsByCategory = productsByCategory;
        _cachedCategories = categories;
        _lastFetch = DateTime.now();
        // Inicializar visibilidad para animaciones
        final selectedCategory = categories.isNotEmpty ? categories[0] : null;
        final productsList = selectedCategory != null ? productsByCategory[selectedCategory] ?? [] : [];
        visibleItems = List.generate(productsList.length, (_) => false);
        _runAppearAnimation(productsList.length);
        setState(() {});
      } else {
        setState(() {
          error = 'Error al cargar productos: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'No se pudo conectar con la API.';
        loading = false;
      });
    }
  }

  void _runAppearAnimation(int count) async {
    for (int i = 0; i < count; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (mounted) {
        setState(() {
          visibleItems[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
      color: Theme.of(context).colorScheme.background.withOpacity(0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            'Nuestras Especialidades',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Desde clásicos reconfortantes hasta nuevas delicias, ¡hay algo para todos!',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          if (loading)
            const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: CircularProgressIndicator())
          else if (error != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(error!, style: const TextStyle(color: Colors.red)),
            )
          else if (categories.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: Text('No hay productos disponibles.'))
          else ...[
            // Tabs de categorías
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  // Flecha izquierda
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      if (selectedCategoryIndex > 0) {
                        setState(() => selectedCategoryIndex--);
                        _scrollToCategory(selectedCategoryIndex);
                      }
                    },
                    color: selectedCategoryIndex > 0 ? Theme.of(context).colorScheme.primary : Colors.grey[400],
                  ),
                  // Lista de categorías
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, idx) {
                        final selected = idx == selectedCategoryIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() => selectedCategoryIndex = idx);
                            _scrollToCategory(idx);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: selected ? Colors.yellow.withOpacity(1) : Colors.yellow,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                if (selected)
                                  BoxShadow(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                categories[idx],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: selected ? Theme.of(context).colorScheme.primary : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Flecha derecha
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      if (selectedCategoryIndex < categories.length - 1) {
                        setState(() => selectedCategoryIndex++);
                        _scrollToCategory(selectedCategoryIndex);
                      }
                    },
                    color: selectedCategoryIndex < categories.length - 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[400],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Productos de la categoría seleccionada
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 1;
                if (constraints.maxWidth > 1200) {
                  crossAxisCount = 2;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 1;
                }
                final selectedCategory = categories[selectedCategoryIndex];
                final productsList = productsByCategory[selectedCategory] ?? [];
                // Reiniciar animación si cambia la categoría
                if (visibleItems.length != productsList.length) {
                  visibleItems = List.generate(productsList.length, (_) => false);
                  _runAppearAnimation(productsList.length);
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3.5,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, idx) {
                    return AnimatedOpacity(
                      opacity: visibleItems.length > idx && visibleItems[idx] ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: ProductCard(product: productsList[idx]),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 0),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2E8), // Fondo claro
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen cuadrada con bordes redondeados
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              width: 90,
              height: 90,
              child: product['image_url'] != null && product['image_url'].toString().isNotEmpty
                  ? Image.network(
                      product['image_url'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 36, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 36, color: Colors.grey),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          // Título y descripción
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width>=600?300:MediaQuery.of(context).size.width * 0.46,
                      child: Text(
                        product['name'] ?? '',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF44474F),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '\$${double.parse(product['price'].toString()).toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF6EC6E6),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  product['description'] ?? '',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w400),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),

          // Precio destacado
        ],
      ),
    );
  }
}
