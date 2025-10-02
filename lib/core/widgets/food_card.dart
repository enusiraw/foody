import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Reusable food item card widget
/// Displays food item information in a consistent card format
class FoodCard extends StatelessWidget {
  final FoodItem foodItem;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.foodItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            _buildInfoSection(isDark),
          ],
        ),
      ),
    );
  }

  /// Build the image section of the card
  Widget _buildImageSection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: Text(
          foodItem.imageUrl,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }

  /// Build the information section of the card
  Widget _buildInfoSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            foodItem.name,
            style: AppTextStyles.cardTitle.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildMetaInfo(isDark),
          const SizedBox(height: 8),
          _buildPriceAndAction(isDark),
        ],
      ),
    );
  }

  /// Build metadata row (rating and prep time)
  Widget _buildMetaInfo(bool isDark) {
    return Row(
      children: [
        Icon(Icons.star, size: 14, color: AppColors.rating),
        const SizedBox(width: 4),
        Text(
          foodItem.rating.toString(),
          style: AppTextStyles.caption.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.access_time,
          size: 14,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        const SizedBox(width: 4),
        Text(
          '${foodItem.preparationTime} min',
          style: AppTextStyles.caption.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  /// Build price and add button
  Widget _buildPriceAndAction(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '\$${foodItem.price.toStringAsFixed(2)}',
          style: AppTextStyles.priceSmall,
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          ),
        ),
      ],
    );
  }
}
