import '../models/cart_item.dart';
import '../models/order.dart';

class OrderRepository {
  int _orderCounter = 1000;

  Future<Order> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double tax,
    required double total,
    required String deliveryAddress,
    String? specialInstructions,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulate potential network errors (10% chance)
    if (DateTime.now().millisecond % 10 == 0) {
      throw Exception('Network error: Unable to connect to server');
    }

    _orderCounter++;

    final order = Order(
      id: 'ORD-${_orderCounter.toString().padLeft(6, '0')}',
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      specialInstructions: specialInstructions,
    );

    return order;
  }

  Future<Order> getOrderById(String orderId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // This would normally fetch from a database
    throw UnimplementedError('Order retrieval not implemented in this demo');
  }

  Future<List<Order>> getUserOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // This would normally fetch user's order history
    throw UnimplementedError('Order history not implemented in this demo');
  }
}
