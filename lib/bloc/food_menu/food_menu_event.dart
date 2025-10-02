import 'package:equatable/equatable.dart';

abstract class FoodMenuEvent extends Equatable {
  const FoodMenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadFoodMenu extends FoodMenuEvent {
  final String? restaurantId;
  final String? category;

  const LoadFoodMenu({this.restaurantId, this.category});

  @override
  List<Object?> get props => [restaurantId, category];
}

class FilterByCategory extends FoodMenuEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchFood extends FoodMenuEvent {
  final String query;

  const SearchFood(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshMenu extends FoodMenuEvent {
  const RefreshMenu();
}
