import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/food_item.dart';
import '../../repositories/food_repository.dart';
import 'food_menu_event.dart';
import 'food_menu_state.dart';

class FoodMenuBloc extends Bloc<FoodMenuEvent, FoodMenuState> {
  final FoodRepository foodRepository;

  FoodMenuBloc({required this.foodRepository}) : super(const FoodMenuInitial()) {
    on<LoadFoodMenu>(_onLoadFoodMenu);
    on<FilterByCategory>(_onFilterByCategory);
    on<SearchFood>(_onSearchFood);
    on<RefreshMenu>(_onRefreshMenu);
  }

  Future<void> _onLoadFoodMenu(
    LoadFoodMenu event,
    Emitter<FoodMenuState> emit,
  ) async {
    try {
      emit(const FoodMenuLoading());
      
      final foodItems = await foodRepository.getFoodItems(
        restaurantId: event.restaurantId,
        category: event.category,
      );

      if (foodItems.isEmpty) {
        emit(const FoodMenuError(
          message: 'No food items available at the moment',
          errorCode: 'EMPTY_MENU',
        ));
        return;
      }

      final categories = _extractCategories(foodItems);

      emit(FoodMenuLoaded(
        foodItems: foodItems,
        selectedCategory: event.category,
        availableCategories: categories,
      ));
    } catch (e) {
      emit(FoodMenuError(
        message: 'Failed to load menu: ${e.toString()}',
        errorCode: 'LOAD_ERROR',
      ));
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<FoodMenuState> emit,
  ) async {
    if (state is! FoodMenuLoaded) return;

    try {
      emit(const FoodMenuLoading());

      final foodItems = await foodRepository.getFoodItems(
        category: event.category,
      );

      final currentState = state as FoodMenuLoaded;

      emit(FoodMenuLoaded(
        foodItems: foodItems,
        selectedCategory: event.category,
        availableCategories: currentState.availableCategories,
      ));
    } catch (e) {
      emit(FoodMenuError(
        message: 'Failed to filter menu: ${e.toString()}',
        errorCode: 'FILTER_ERROR',
      ));
    }
  }

  Future<void> _onSearchFood(
    SearchFood event,
    Emitter<FoodMenuState> emit,
  ) async {
    if (state is! FoodMenuLoaded) return;

    try {
      final currentState = state as FoodMenuLoaded;

      if (event.query.isEmpty) {
        final allItems = await foodRepository.getFoodItems();
        emit(currentState.copyWith(foodItems: allItems));
        return;
      }

      final filteredItems = await foodRepository.searchFoodItems(event.query);

      emit(currentState.copyWith(foodItems: filteredItems));
    } catch (e) {
      emit(FoodMenuError(
        message: 'Search failed: ${e.toString()}',
        errorCode: 'SEARCH_ERROR',
      ));
    }
  }

  Future<void> _onRefreshMenu(
    RefreshMenu event,
    Emitter<FoodMenuState> emit,
  ) async {
    try {
      final foodItems = await foodRepository.getFoodItems();
      final categories = _extractCategories(foodItems);

      emit(FoodMenuLoaded(
        foodItems: foodItems,
        availableCategories: categories,
      ));
    } catch (e) {
      emit(FoodMenuError(
        message: 'Failed to refresh menu: ${e.toString()}',
        errorCode: 'REFRESH_ERROR',
      ));
    }
  }

  List<String> _extractCategories(List<FoodItem> items) {
    final categories = items.map((item) => item.category).toSet().toList();
    categories.sort();
    return categories;
  }
}
