import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/bloc/cart/cart_bloc.dart';
import 'package:foody/bloc/cart/cart_event.dart';
import 'package:foody/bloc/cart/cart_state.dart';
import 'package:foody/models/food_item.dart';
import 'package:foody/models/cart_item.dart';

void main() {
  group('CartBloc', () {
    late CartBloc cartBloc;

    setUp(() {
      cartBloc = CartBloc();
    });

    tearDown(() {
      cartBloc.close();
    });

    const testFoodItem = FoodItem(
      id: '1',
      name: 'Test Burger',
      description: 'A delicious test burger',
      price: 10.00,
      imageUrl: '🍔',
      category: 'Burgers',
      restaurantId: 'r1',
      rating: 4.5,
      preparationTime: 15,
      isAvailable: true,
    );

    test('initial state is CartInitial', () {
      expect(cartBloc.state, equals(const CartInitial()));
    });

    blocTest<CartBloc, CartState>(
      'emits CartLoaded when LoadCart is added',
      build: () => cartBloc,
      act: (bloc) => bloc.add(const LoadCart()),
      expect: () => [
        const CartLoaded(
          items: [],
          subtotal: 0,
          deliveryFee: 0,
          tax: 0,
          total: 0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits CartLoaded with item when AddToCart is added',
      build: () => cartBloc,
      seed: () => const CartLoaded(
        items: [],
        subtotal: 0,
        deliveryFee: 0,
        tax: 0,
        total: 0,
      ),
      act: (bloc) => bloc.add(const AddToCart(foodItem: testFoodItem)),
      expect: () => [
        isA<CartLoaded>()
            .having((state) => state.items.length, 'items length', 1)
            .having((state) => state.items.first.foodItem.id, 'food item id', '1')
            .having((state) => state.items.first.quantity, 'quantity', 1)
            .having((state) => state.subtotal, 'subtotal', 10.00),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits CartError when adding unavailable item',
      build: () => cartBloc,
      seed: () => const CartLoaded(
        items: [],
        subtotal: 0,
        deliveryFee: 0,
        tax: 0,
        total: 0,
      ),
      act: (bloc) => bloc.add(AddToCart(
        foodItem: testFoodItem.copyWith(isAvailable: false),
      )),
      expect: () => [
        const CartError(
          message: 'This item is currently unavailable',
          errorCode: 'ITEM_UNAVAILABLE',
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'updates quantity when same item is added again',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: [
          const CartItem(foodItem: testFoodItem, quantity: 1),
        ],
        subtotal: 10.00,
        deliveryFee: 5.99,
        tax: 0.80,
        total: 16.79,
      ),
      act: (bloc) => bloc.add(const AddToCart(foodItem: testFoodItem, quantity: 2)),
      expect: () => [
        isA<CartLoaded>()
            .having((state) => state.items.length, 'items length', 1)
            .having((state) => state.items.first.quantity, 'quantity', 3),
      ],
    );

    blocTest<CartBloc, CartState>(
      'removes item from cart when RemoveFromCart is added',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: [
          const CartItem(foodItem: testFoodItem, quantity: 1),
        ],
        subtotal: 10.00,
        deliveryFee: 5.99,
        tax: 0.80,
        total: 16.79,
      ),
      act: (bloc) => bloc.add(const RemoveFromCart('1')),
      expect: () => [
        const CartLoaded(
          items: [],
          subtotal: 0,
          deliveryFee: 0,
          tax: 0,
          total: 0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'updates item quantity when UpdateCartItemQuantity is added',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: [
          const CartItem(foodItem: testFoodItem, quantity: 1),
        ],
        subtotal: 10.00,
        deliveryFee: 5.99,
        tax: 0.80,
        total: 16.79,
      ),
      act: (bloc) => bloc.add(const UpdateCartItemQuantity(
        foodItemId: '1',
        quantity: 3,
      )),
      expect: () => [
        isA<CartLoaded>()
            .having((state) => state.items.first.quantity, 'quantity', 3)
            .having((state) => state.subtotal, 'subtotal', 30.00),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits error when updating quantity to less than 1',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: [
          const CartItem(foodItem: testFoodItem, quantity: 1),
        ],
        subtotal: 10.00,
        deliveryFee: 5.99,
        tax: 0.80,
        total: 16.79,
      ),
      act: (bloc) => bloc.add(const UpdateCartItemQuantity(
        foodItemId: '1',
        quantity: 0,
      )),
      expect: () => [
        const CartError(
          message: 'Quantity must be at least 1',
          errorCode: 'INVALID_QUANTITY',
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'clears cart when ClearCart is added',
      build: () => cartBloc,
      seed: () => CartLoaded(
        items: [
          const CartItem(foodItem: testFoodItem, quantity: 2),
        ],
        subtotal: 20.00,
        deliveryFee: 5.99,
        tax: 1.60,
        total: 27.59,
      ),
      act: (bloc) => bloc.add(const ClearCart()),
      expect: () => [
        const CartLoaded(
          items: [],
          subtotal: 0,
          deliveryFee: 0,
          tax: 0,
          total: 0,
        ),
      ],
    );

    blocTest<CartBloc, CartState>(
      'calculates correct totals with tax and delivery fee',
      build: () => cartBloc,
      seed: () => const CartLoaded(
        items: [],
        subtotal: 0,
        deliveryFee: 0,
        tax: 0,
        total: 0,
      ),
      act: (bloc) => bloc.add(const AddToCart(foodItem: testFoodItem, quantity: 2)),
      expect: () => [
        isA<CartLoaded>()
            .having((state) => state.subtotal, 'subtotal', 20.00)
            .having((state) => state.deliveryFee, 'delivery fee', 5.99)
            .having((state) => state.tax, 'tax', closeTo(1.60, 0.01))
            .having((state) => state.total, 'total', closeTo(27.59, 0.01)),
      ],
    );
  });
}
