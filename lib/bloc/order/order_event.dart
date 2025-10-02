import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrder extends OrderEvent {
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String deliveryAddress;
  final String? specialInstructions;

  const PlaceOrder({
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.deliveryAddress,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [
        items,
        subtotal,
        deliveryFee,
        tax,
        total,
        deliveryAddress,
        specialInstructions,
      ];
}

class ResetOrder extends OrderEvent {
  const ResetOrder();
}
