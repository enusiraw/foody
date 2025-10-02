import 'package:equatable/equatable.dart';
import '../../models/food_item.dart';

abstract class FoodMenuState extends Equatable {
  const FoodMenuState();

  @override
  List<Object?> get props => [];
}

class FoodMenuInitial extends FoodMenuState {
  const FoodMenuInitial();
}

class FoodMenuLoading extends FoodMenuState {
  const FoodMenuLoading();
}

class FoodMenuLoaded extends FoodMenuState {
  final List<FoodItem> foodItems;
  final String? selectedCategory;
  final List<String> availableCategories;

  const FoodMenuLoaded({
    required this.foodItems,
    this.selectedCategory,
    this.availableCategories = const [],
  });

  @override
  List<Object?> get props => [foodItems, selectedCategory, availableCategories];

  FoodMenuLoaded copyWith({
    List<FoodItem>? foodItems,
    String? selectedCategory,
    List<String>? availableCategories,
  }) {
    return FoodMenuLoaded(
      foodItems: foodItems ?? this.foodItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}

class FoodMenuError extends FoodMenuState {
  final String message;
  final String? errorCode;

  const FoodMenuError({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}
