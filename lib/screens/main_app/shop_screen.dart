import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../styles/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';
import '../../providers/favourites_provider.dart';
import '../../providers/cart_provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = productsProvider.products;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'Shop',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        SizedBox(width: 12),
                        Icon(Icons.search, color: AppColors.primary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Search...',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.72,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductItem(products[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Consumer<FavouritesProvider>(
      builder: (context, favouritesProvider, child) {
        final isFavourite = favouritesProvider.isFavourite(product.id);
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 183,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white,
                      border: Border.all(
                        color: AppColors.white, 
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), 
                      child: Image.asset(
                        product.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  Positioned(
                    top: 12, 
                    left: 12,
                    child: GestureDetector(
                      onTap: () {
                        favouritesProvider.toggleFavourite(product);
                      },
                      child: Icon(
                        isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: isFavourite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return GestureDetector(
                          onTap: () {
                            cartProvider.addToCart(product);
                            _showAddedToCartSnackbar(context, product.name);
                          },
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: AppColors.textDark,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}'.replaceAll('.', ','),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddedToCartSnackbar(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$productName added to cart'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}