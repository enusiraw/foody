import '../models/food_item.dart';
import '../data/mock_data.dart';

/// Repository for food-related data operations
/// Implements data layer separation following repository pattern
class FoodRepository {
  // Get food items from mock data source
  List<FoodItem> get _foodItems => MockData.foodItems;

  /// Fetch all food items or filter by parameters
  Future<List<FoodItem>> getFoodItems({
    String? restaurantId,
    String? category,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var items = List<FoodItem>.from(_foodItems);

    if (restaurantId != null) {
      items = items.where((item) => item.restaurantId == restaurantId).toList();
    }

    if (category != null) {
      items = items.where((item) => item.category == category).toList();
    }

    return items;
  }

  Future<List<FoodItem>> searchFoodItems(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final lowercaseQuery = query.toLowerCase();
    return _foodItems
        .where((item) =>
            item.name.toLowerCase().contains(lowercaseQuery) ||
            item.description.toLowerCase().contains(lowercaseQuery) ||
            item.category.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  Future<FoodItem?> getFoodItemById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    try {
      return _foodItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
