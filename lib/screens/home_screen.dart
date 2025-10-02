import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/food_menu/food_menu_bloc.dart';
import '../bloc/food_menu/food_menu_event.dart';
import '../bloc/food_menu/food_menu_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_state.dart';
import '../models/food_item.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/widgets/food_card.dart';
import '../core/widgets/category_chip.dart';
import '../core/widgets/loading_indicator.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/empty_state.dart';
import '../core/routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<FoodMenuBloc>().add(const LoadFoodMenu());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryFilter(),
            Expanded(child: _buildFoodList()),
          ],
        ),
      ),
      floatingActionButton: _buildCartButton(),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Foody',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Delivering happiness 🍕',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.iconBackgroundDark : AppColors.iconBackgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          context.read<FoodMenuBloc>().add(SearchFood(value));
        },
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: 'Search for food...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<FoodMenuBloc>().add(const SearchFood(''));
                  },
                )
              : null,
          filled: true,
          fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<FoodMenuBloc, FoodMenuState>(
      builder: (context, state) {
        if (state is! FoodMenuLoaded) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.availableCategories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return CategoryChip(
                  label: 'All',
                  isSelected: state.selectedCategory == null,
                  onTap: () {
                    context.read<FoodMenuBloc>().add(const LoadFoodMenu());
                  },
                );
              }

              final category = state.availableCategories[index - 1];
              return CategoryChip(
                label: category,
                isSelected: state.selectedCategory == category,
                onTap: () {
                  context.read<FoodMenuBloc>().add(FilterByCategory(category));
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFoodList() {
    return BlocBuilder<FoodMenuBloc, FoodMenuState>(
      builder: (context, state) {
        if (state is FoodMenuLoading) {
          return const LoadingIndicator(message: 'Loading menu...');
        }

        if (state is FoodMenuError) {
          return ErrorView(
            message: state.message,
            onRetry: () {
              context.read<FoodMenuBloc>().add(const RefreshMenu());
            },
          );
        }

        if (state is FoodMenuLoaded) {
          if (state.foodItems.isEmpty) {
            return const EmptyState(
              emoji: '🔍',
              title: 'No food items found',
              subtitle: 'Try adjusting your search or filters',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FoodMenuBloc>().add(const RefreshMenu());
            },
            color: AppColors.primary,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.foodItems.length,
              itemBuilder: (context, index) {
                return _buildFoodCard(state.foodItems[index]);
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFoodCard(FoodItem item) {
    return FoodCard(
      foodItem: item,
      onTap: () {
        AppRoutes.navigateToFoodDetail(context, item);
      },
    );
  }

  Widget _buildCartButton() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is! CartLoaded || state.isEmpty) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () {
            AppRoutes.navigateToCart(context);
          },
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          label: Text(
            'Cart (${state.itemCount}) • \$${state.total.toStringAsFixed(2)}',
            style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
          ),
        );
      },
    );
  }
}
