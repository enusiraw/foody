import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/cart_item.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  static const double deliveryFeeAmount = 5.99;
  static const double taxRate = 0.08; // 8% tax

  CartBloc() : super(const CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
    on<UpdateSpecialInstructions>(_onUpdateSpecialInstructions);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      if (!event.foodItem.isAvailable) {
        emit(const CartError(
          message: 'This item is currently unavailable',
          errorCode: 'ITEM_UNAVAILABLE',
        ));
        return;
      }

      final currentState = state is CartLoaded
          ? state as CartLoaded
          : const CartLoaded(
              items: [],
              subtotal: 0,
              deliveryFee: 0,
              tax: 0,
              total: 0,
            );

      final items = List<CartItem>.from(currentState.items);

      // Check if item already exists in cart
      final existingIndex = items.indexWhere(
        (item) => item.foodItem.id == event.foodItem.id,
      );

      if (existingIndex != -1) {
        // Update quantity if item exists
        final existingItem = items[existingIndex];
        items[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + event.quantity,
          specialInstructions: event.specialInstructions ?? existingItem.specialInstructions,
        );
      } else {
        // Add new item
        items.add(CartItem(
          foodItem: event.foodItem,
          quantity: event.quantity,
          specialInstructions: event.specialInstructions,
        ));
      }

      _emitUpdatedCart(emit, items);
    } catch (e) {
      emit(CartError(
        message: 'Failed to add item to cart: ${e.toString()}',
        errorCode: 'ADD_ERROR',
      ));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) return;

    try {
      final currentState = state as CartLoaded;
      final items = List<CartItem>.from(currentState.items);

      items.removeWhere((item) => item.foodItem.id == event.foodItemId);

      if (items.isEmpty) {
        emit(const CartLoaded(
          items: [],
          subtotal: 0,
          deliveryFee: 0,
          tax: 0,
          total: 0,
        ));
      } else {
        _emitUpdatedCart(emit, items);
      }
    } catch (e) {
      emit(CartError(
        message: 'Failed to remove item: ${e.toString()}',
        errorCode: 'REMOVE_ERROR',
      ));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) return;

    try {
      if (event.quantity < 1) {
        emit(const CartError(
          message: 'Quantity must be at least 1',
          errorCode: 'INVALID_QUANTITY',
        ));
        return;
      }

      final currentState = state as CartLoaded;
      final items = List<CartItem>.from(currentState.items);

      final index = items.indexWhere(
        (item) => item.foodItem.id == event.foodItemId,
      );

      if (index != -1) {
        items[index] = items[index].copyWith(quantity: event.quantity);
        _emitUpdatedCart(emit, items);
      }
    } catch (e) {
      emit(CartError(
        message: 'Failed to update quantity: ${e.toString()}',
        errorCode: 'UPDATE_ERROR',
      ));
    }
  }

  Future<void> _onUpdateSpecialInstructions(
    UpdateSpecialInstructions event,
    Emitter<CartState> emit,
  ) async {
    if (state is! CartLoaded) return;

    try {
      final currentState = state as CartLoaded;
      final items = List<CartItem>.from(currentState.items);

      final index = items.indexWhere(
        (item) => item.foodItem.id == event.foodItemId,
      );

      if (index != -1) {
        items[index] = items[index].copyWith(
          specialInstructions: event.instructions,
        );
        _emitUpdatedCart(emit, items);
      }
    } catch (e) {
      emit(CartError(
        message: 'Failed to update instructions: ${e.toString()}',
        errorCode: 'UPDATE_ERROR',
      ));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoaded(
      items: [],
      subtotal: 0,
      deliveryFee: 0,
      tax: 0,
      total: 0,
    ));
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoaded(
      items: [],
      subtotal: 0,
      deliveryFee: 0,
      tax: 0,
      total: 0,
    ));
  }

  void _emitUpdatedCart(Emitter<CartState> emit, List<CartItem> items) {
    final subtotal = items.fold<double>(
      0,
      (sum, item) => sum + item.totalPrice,
    );

    final deliveryFee = items.isEmpty ? 0.0 : deliveryFeeAmount;
    final tax = subtotal * taxRate;
    final total = subtotal + deliveryFee + tax;

    emit(CartLoaded(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
    ));
  }
}
