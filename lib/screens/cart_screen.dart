import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/order/order_bloc.dart';
import '../bloc/order/order_event.dart';
import '../bloc/order/order_state.dart';
import '../models/cart_item.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import 'order_confirmation_screen.dart';

/// Clean, compact Cart Screen matching reference design
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder(List<CartItem> items, double subtotal, double deliveryFee,
      double tax, double total) {
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a delivery address'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.read<OrderBloc>().add(
          PlaceOrder(
            items: items,
            subtotal: subtotal,
            deliveryFee: deliveryFee,
            tax: tax,
            total: total,
            deliveryAddress: _addressController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderPlaced) {
          context.read<CartBloc>().add(const ClearCart());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(order: state.order),
            ),
          );
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('My Cart'),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return _buildEmptyCart(isDark);
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCartItems(state.items, isDark),
                          const SizedBox(height: 20),
                          _buildDeliveryAddress(isDark),
                          const SizedBox(height: 20),
                          _buildPriceSummary(
                            state.subtotal,
                            state.deliveryFee,
                            state.tax,
                            state.total,
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildCheckoutButton(
                    state.items,
                    state.subtotal,
                    state.deliveryFee,
                    state.tax,
                    state.total,
                    isDark,
                  ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: AppTextStyles.h3.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to get started!',
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<CartItem> items, bool isDark) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildCartItemRow(item, isDark);
      },
    );
  }

  Widget _buildCartItemRow(CartItem item, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              item.foodItem.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🍔', style: TextStyle(fontSize: 32))),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Item info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.foodItem.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.foodItem.price.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Quantity controls
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (item.quantity > 1) {
                            context.read<CartBloc>().add(
                                  UpdateCartItemQuantity(
                                    foodItemId: item.foodItem.id,
                                    quantity: item.quantity - 1,
                                  ),
                                );
                          } else {
                            context.read<CartBloc>().add(RemoveFromCart(item.foodItem.id));
                          }
                        },
                        icon: const Icon(Icons.remove, size: 18),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(
                                UpdateCartItemQuantity(
                                  foodItemId: item.foodItem.id,
                                  quantity: item.quantity + 1,
                                ),
                              );
                        },
                        icon: const Icon(Icons.add, size: 18),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Price and delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${item.totalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.h4.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () {
                  context.read<CartBloc>().add(RemoveFromCart(item.foodItem.id));
                },
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppColors.error,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address',
          style: AppTextStyles.h4.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(
            hintText: 'Enter delivery address',
            prefixIcon: const Icon(Icons.location_on_outlined),
            filled: true,
            fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildPriceSummary(
    double subtotal,
    double deliveryFee,
    double tax,
    double total,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', subtotal, isDark),
          const SizedBox(height: 12),
          _buildPriceRow('Delivery', deliveryFee, isDark),
          const SizedBox(height: 12),
          _buildPriceRow('Tax', tax, isDark),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
          _buildPriceRow('Total', total, isDark, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, bool isDark, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (isTotal ? AppTextStyles.h4 : AppTextStyles.bodyMedium).copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: (isTotal ? AppTextStyles.h4 : AppTextStyles.bodyMedium).copyWith(
            color: isTotal ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(
    List<CartItem> items,
    double subtotal,
    double deliveryFee,
    double tax,
    double total,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final isLoading = state is OrderPlacing;

          return ElevatedButton(
            onPressed: isLoading ? null : () => _placeOrder(items, subtotal, deliveryFee, tax, total),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Checkout • \$${total.toStringAsFixed(2)}',
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
