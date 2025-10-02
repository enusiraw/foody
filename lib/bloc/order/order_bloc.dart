import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';
import '../../repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  OrderBloc({required this.orderRepository}) : super(const OrderInitial()) {
    on<PlaceOrder>(_onPlaceOrder);
    on<ResetOrder>(_onResetOrder);
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(const OrderPlacing());

      // Validate order
      if (event.items.isEmpty) {
        emit(const OrderError(
          message: 'Cannot place an empty order',
          errorCode: 'EMPTY_ORDER',
        ));
        return;
      }

      if (event.deliveryAddress.trim().isEmpty) {
        emit(const OrderError(
          message: 'Please provide a delivery address',
          errorCode: 'MISSING_ADDRESS',
        ));
        return;
      }

      // Check if all items are available
      final unavailableItems = event.items
          .where((item) => !item.foodItem.isAvailable)
          .toList();

      if (unavailableItems.isNotEmpty) {
        emit(OrderError(
          message: 'Some items in your cart are no longer available: ${unavailableItems.map((e) => e.foodItem.name).join(", ")}',
          errorCode: 'ITEMS_UNAVAILABLE',
        ));
        return;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Place the order
      final order = await orderRepository.placeOrder(
        items: event.items,
        subtotal: event.subtotal,
        deliveryFee: event.deliveryFee,
        tax: event.tax,
        total: event.total,
        deliveryAddress: event.deliveryAddress,
        specialInstructions: event.specialInstructions,
      );

      emit(OrderPlaced(order));
    } catch (e) {
      emit(OrderError(
        message: 'Failed to place order: ${e.toString()}',
        errorCode: 'ORDER_ERROR',
      ));
    }
  }

  Future<void> _onResetOrder(
    ResetOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderInitial());
  }
}
