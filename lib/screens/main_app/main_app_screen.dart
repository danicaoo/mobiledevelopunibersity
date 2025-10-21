import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../styles/app_colors.dart';
import 'shop_screen.dart';
import 'favourites_screen.dart';
import 'cart_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favourites_provider.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ShopScreen(),
    FavouritesScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favouritesProvider = Provider.of<FavouritesProvider>(context);

    return Scaffold(
      appBar: _currentIndex == 0 
          ? null 
          : AppBar(
              title: Text(
                _currentIndex == 1 ? 'Favourites' : 'Cart',
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.w800, 
                  color: AppColors.textDark,
                ),
              ),
              backgroundColor: AppColors.white,
              elevation: 0,
              foregroundColor: AppColors.textDark,
            ),
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildCustomBottomNavigationBar(cartProvider, favouritesProvider),
    );
  }

  Widget _buildCustomBottomNavigationBar(CartProvider cartProvider, FavouritesProvider favouritesProvider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              icon: Icons.shopping_bag,
              isActive: _currentIndex == 0,
              badgeCount: 0,
              onTap: () => _onItemTapped(0),
            ),
            _buildNavItem(
              icon: Icons.favorite,
              isActive: _currentIndex == 1,
              badgeCount: favouritesProvider.favouriteProducts.length,
              onTap: () => _onItemTapped(1),
            ),
            _buildNavItem(
              icon: Icons.shopping_cart,
              isActive: _currentIndex == 2,
              badgeCount: cartProvider.totalItems,
              onTap: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isActive,
    required int badgeCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  size: 24,
                  color: isActive ? AppColors.primary : AppColors.textLight,
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          if (isActive)
            Container(
              width: 24,
              height: 3,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(1.5),
              ),
            )
          else
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}