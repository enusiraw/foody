import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_menu/food_menu_bloc.dart';
import '../bloc/food_menu/food_menu_event.dart';
import '../bloc/food_menu/food_menu_state.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/routes/app_routes.dart';
import '../core/widgets/error_view.dart';
import '../core/widgets/food_card.dart';
import '../core/widgets/loading_indicator.dart';

/// Modern, clean Home Screen with improved UI/UX
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
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

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    if (category == 'All') {
      context.read<FoodMenuBloc>().add(const LoadFoodMenu());
    } else {
      context.read<FoodMenuBloc>().add(FilterByCategory(category));
    }
  }

  void _onSearch(String query) {
    setState(() {}); // Rebuild to show/hide clear button
    if (query.isEmpty) {
      context.read<FoodMenuBloc>().add(const LoadFoodMenu());
    } else {
      context.read<FoodMenuBloc>().add(SearchFood(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildSearchBar(isDark),
            _buildCategoryTabs(isDark),
            Expanded(child: _buildFoodGrid()),
          ],
        ),
      ),
    );
  }

  /// Build modern header with greeting
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Foody',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Delivering happiness 🍕',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [Colors.grey[800]!, Colors.grey[700]!]
                    : [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05)
                      ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Badge(
              backgroundColor: Colors.red,
              smallSize: 8,
              offset: const Offset(4, -4),
              child: Icon(
                Icons.notifications_outlined,
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search for food...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: () {
                _searchController.clear();
                _onSearch('');
              },
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
        ],
      ),
    );
  }

  /// Build horizontal category tabs
  Widget _buildCategoryTabs(bool isDark) {
    final categories = [
      'All',
      'Burgers',
      'Pizza',
      'Sushi',
      'Desserts',
      'Drinks'
    ];

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () => _onCategorySelected(category),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.cardDark : AppColors.cardLight),
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build food grid
  Widget _buildFoodGrid() {
    return BlocBuilder<FoodMenuBloc, FoodMenuState>(
      builder: (context, state) {
        if (state is FoodMenuLoading) {
          return const LoadingIndicator();
        }

        if (state is FoodMenuError) {
          return ErrorView(
            message: state.message,
            onRetry: () {
              context.read<FoodMenuBloc>().add(const LoadFoodMenu());
            },
          );
        }

        if (state is FoodMenuLoaded) {
          if (state.foodItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('😔', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    'No food items found',
                    style: AppTextStyles.h4.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = state.foodItems[index];
              return FoodCard(
                foodItem: foodItem,
                onTap: () {
                  AppRoutes.navigateToFoodDetail(context, foodItem);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
