import 'package:equatable/equatable.dart';

class FoodItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String restaurantId;
  final double rating;
  final int preparationTime; // in minutes
  final List<String> allergens;
  final bool isAvailable;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.restaurantId,
    this.rating = 0.0,
    this.preparationTime = 30,
    this.allergens = const [],
    this.isAvailable = true,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        imageUrl,
        category,
        restaurantId,
        rating,
        preparationTime,
        allergens,
        isAvailable,
      ];

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    String? restaurantId,
    double? rating,
    int? preparationTime,
    List<String>? allergens,
    bool? isAvailable,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      restaurantId: restaurantId ?? this.restaurantId,
      rating: rating ?? this.rating,
      preparationTime: preparationTime ?? this.preparationTime,
      allergens: allergens ?? this.allergens,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
