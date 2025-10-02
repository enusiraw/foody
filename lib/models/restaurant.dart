import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTime; // in minutes
  final double deliveryFee;
  final List<String> categories;
  final bool isOpen;
  final String address;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.categories,
    this.isOpen = true,
    this.address = '',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        rating,
        deliveryTime,
        deliveryFee,
        categories,
        isOpen,
        address,
      ];

  Restaurant copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? rating,
    int? deliveryTime,
    double? deliveryFee,
    List<String>? categories,
    bool? isOpen,
    String? address,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      categories: categories ?? this.categories,
      isOpen: isOpen ?? this.isOpen,
      address: address ?? this.address,
    );
  }
}
