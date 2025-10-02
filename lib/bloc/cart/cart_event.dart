import 'package:equatable/equatable.dart';
import '../../models/food_item.dart';
import '../../models/cart_item.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCart extends CartEvent {
  final FoodItem foodItem;
  final int quantity;
  final String? specialInstructions;

  const AddToCart({
    required this.foodItem,
    this.quantity = 1,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [foodItem, quantity, specialInstructions];
}

class RemoveFromCart extends CartEvent {
  final String foodItemId;

  const RemoveFromCart(this.foodItemId);

  @override
  List<Object?> get props => [foodItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String foodItemId;
  final int quantity;

  const UpdateCartItemQuantity({
    required this.foodItemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [foodItemId, quantity];
}

class UpdateSpecialInstructions extends CartEvent {
  final String foodItemId;
  final String instructions;

  const UpdateSpecialInstructions({
    required this.foodItemId,
    required this.instructions,
  });

  @override
  List<Object?> get props => [foodItemId, instructions];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class LoadCart extends CartEvent {
  const LoadCart();
}
