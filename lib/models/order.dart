import 'package:equatable/equatable.dart';
import 'cart_item.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final String deliveryAddress;
  final String? specialInstructions;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        subtotal,
        deliveryFee,
        tax,
        total,
        status,
        createdAt,
        deliveryAddress,
        specialInstructions,
      ];

  Order copyWith({
    String? id,
    List<CartItem>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    OrderStatus? status,
    DateTime? createdAt,
    String? deliveryAddress,
    String? specialInstructions,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
