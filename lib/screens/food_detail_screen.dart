import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../models/food_item.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

/// Modern, high-fidelity Food Detail Screen
/// Fully responsive with proper spacing and alignment
class FoodDetailScreen extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetailScreen({
    super.key,
    required this.foodItem,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    context.read<CartBloc>().add(
          AddToCart(
            foodItem: widget.foodItem,
            quantity: _quantity,
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text('${widget.foodItem.name} added to cart!'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  double get _totalPrice => widget.foodItem.price * _quantity;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageHeader(size),
                _buildFoodInfo(isDark),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          ),
          // Fixed header
          _buildHeader(context, isDark),
          // Fixed bottom bar
          _buildBottomBar(isDark),
        ],
      ),
    );
  }

  /// Build header with back and favorite buttons
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.6),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            // Favorite button
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 24,
                  color: _isFavorite ? Colors.red : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build image header with hero animation
  Widget _buildImageHeader(Size size) {
    return Hero(
      tag: 'food-${widget.foodItem.id}',
      child: Container(
        height: size.height * 0.4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.1),
        ),
        child: Image.asset(
          widget.foodItem.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.cardGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  _getCategoryEmoji(widget.foodItem.category),
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'burgers':
        return '🍔';
      case 'pizza':
        return '🍕';
      case 'sushi':
        return '🍱';
      case 'desserts':
        return '🍰';
      case 'drinks':
        return '🥤';
      default:
        return '🍽️';
    }
  }

  /// Build food information section
  Widget _buildFoodInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      transform: Matrix4.translationValues(0, -24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.foodItem.category,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Food name
          Text(
            widget.foodItem.name,
            style: AppTextStyles.h2.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // Rating and prep time
          Row(
            children: [
              Icon(Icons.star, size: 20, color: AppColors.rating),
              const SizedBox(width: 4),
              Text(
                widget.foodItem.rating.toString(),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.access_time,
                size: 20,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.foodItem.preparationTime} min',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Divider
          Divider(
            color: (isDark ? AppColors.dividerDark : AppColors.dividerLight).withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          
          // Description
          Text(
            'Description',
            style: AppTextStyles.h4.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.foodItem.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          
          // Allergens
          if (widget.foodItem.allergens.isNotEmpty) ...[
            Text(
              'Allergens',
              style: AppTextStyles.h4.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.foodItem.allergens.map((allergen) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    allergen,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build bottom bar with quantity selector and add to cart button
  Widget _buildBottomBar(bool isDark) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            // Quantity selector
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Decrease button
                  IconButton(
                    onPressed: _decrementQuantity,
                    icon: const Icon(Icons.remove),
                    color: _quantity > 1 ? AppColors.primary : Colors.grey,
                  ),
                  // Quantity display
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '$_quantity',
                      style: AppTextStyles.h3.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Increase button
                  IconButton(
                    onPressed: _incrementQuantity,
                    icon: const Icon(Icons.add),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Add to cart button
            Expanded(
              child: GestureDetector(
                onTap: _addToCart,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF6B35),
                        Color(0xFFFF8C42),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B35).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Add to Cart',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${_totalPrice.toStringAsFixed(2)}',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
