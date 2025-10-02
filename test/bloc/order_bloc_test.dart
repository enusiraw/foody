import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/bloc/order/order_bloc.dart';
import 'package:foody/bloc/order/order_event.dart';
import 'package:foody/bloc/order/order_state.dart';
import 'package:foody/models/food_item.dart';
import 'package:foody/models/cart_item.dart';
import 'package:foody/repositories/order_repository.dart';

void main() {
  group('OrderBloc', () {
    late OrderBloc orderBloc;
    late OrderRepository orderRepository;

    setUp(() {
      orderRepository = OrderRepository();
      orderBloc = OrderBloc(orderRepository: orderRepository);
    });

    tearDown(() {
      orderBloc.close();
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

    final testCartItems = [
      const CartItem(foodItem: testFoodItem, quantity: 2),
    ];

    test('initial state is OrderInitial', () {
      expect(orderBloc.state, equals(const OrderInitial()));
    });

    blocTest<OrderBloc, OrderState>(
      'emits [OrderPlacing, OrderPlaced] when PlaceOrder is added with valid data',
      build: () => orderBloc,
      act: (bloc) => bloc.add(PlaceOrder(
        items: testCartItems,
        subtotal: 20.00,
        deliveryFee: 5.99,
        tax: 1.60,
        total: 27.59,
        deliveryAddress: '123 Test Street',
      )),
      expect: () => [
        const OrderPlacing(),
        isA<OrderPlaced>()
            .having((state) => state.order.items.length, 'items length', 1)
            .having((state) => state.order.total, 'total', 27.59)
            .having((state) => state.order.deliveryAddress, 'address',
                '123 Test Street'),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderPlacing, OrderError] when PlaceOrder is added with empty items',
      build: () => orderBloc,
      act: (bloc) => bloc.add(const PlaceOrder(
        items: [],
        subtotal: 0,
        deliveryFee: 0,
        tax: 0,
        total: 0,
        deliveryAddress: '123 Test Street',
      )),
      expect: () => [
        const OrderPlacing(),
        const OrderError(
          message: 'Cannot place an empty order',
          errorCode: 'EMPTY_ORDER',
        ),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderPlacing, OrderError] when PlaceOrder is added with empty address',
      build: () => orderBloc,
      act: (bloc) => bloc.add(PlaceOrder(
        items: testCartItems,
        subtotal: 20.00,
        deliveryFee: 5.99,
        tax: 1.60,
        total: 27.59,
        deliveryAddress: '',
      )),
      expect: () => [
        const OrderPlacing(),
        const OrderError(
          message: 'Please provide a delivery address',
          errorCode: 'MISSING_ADDRESS',
        ),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'emits [OrderPlacing, OrderError] when items are unavailable',
      build: () => orderBloc,
      act: (bloc) => bloc.add(PlaceOrder(
        items: [
          CartItem(
            foodItem: testFoodItem.copyWith(isAvailable: false),
            quantity: 1,
          ),
        ],
        subtotal: 10.00,
        deliveryFee: 5.99,
        tax: 0.80,
        total: 16.79,
        deliveryAddress: '123 Test Street',
      )),
      expect: () => [
        const OrderPlacing(),
        isA<OrderError>()
            .having((state) => state.errorCode, 'error code', 'ITEMS_UNAVAILABLE')
            .having((state) => state.message.contains('no longer available'),
                'contains unavailable message', true),
      ],
    );

    blocTest<OrderBloc, OrderState>(
      'resets to OrderInitial when ResetOrder is added',
      build: () => orderBloc,
      seed: () => OrderPlaced(
        orderRepository.placeOrder(
          items: testCartItems,
          subtotal: 20.00,
          deliveryFee: 5.99,
          tax: 1.60,
          total: 27.59,
          deliveryAddress: '123 Test Street',
        ) as dynamic,
      ),
      act: (bloc) => bloc.add(const ResetOrder()),
      expect: () => [
        const OrderInitial(),
      ],
    );
  });
}
