import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../../screens/food_detail_screen.dart';
import '../../screens/cart_screen.dart';
import '../../screens/order_confirmation_screen.dart';
import '../../models/food_item.dart';
import '../../models/order.dart';

/// Application route names
/// Centralized route definitions for named navigation
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Route names
  static const String home = '/';
  static const String foodDetail = '/food-detail';
  static const String cart = '/cart';
  static const String orderConfirmation = '/order-confirmation';

  /// Generate routes based on route settings
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );

      case foodDetail:
        final foodItem = settings.arguments as FoodItem?;
        if (foodItem == null) {
          return _errorRoute('Food item not provided');
        }
        return MaterialPageRoute(
          builder: (_) => FoodDetailScreen(foodItem: foodItem),
          settings: settings,
        );

      case cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
          settings: settings,
        );

      case orderConfirmation:
        final order = settings.arguments as Order?;
        if (order == null) {
          return _errorRoute('Order not provided');
        }
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationScreen(order: order),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  /// Error route for undefined or invalid routes
  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// Navigation helper methods
  /// These methods provide type-safe navigation

  /// Navigate to home screen
  static Future<void> navigateToHome(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      home,
      (route) => false,
    );
  }

  /// Navigate to food detail screen
  static Future<void> navigateToFoodDetail(
    BuildContext context,
    FoodItem foodItem,
  ) {
    return Navigator.pushNamed(
      context,
      foodDetail,
      arguments: foodItem,
    );
  }

  /// Navigate to cart screen
  static Future<void> navigateToCart(BuildContext context) {
    return Navigator.pushNamed(context, cart);
  }

  /// Navigate to order confirmation screen
  static Future<void> navigateToOrderConfirmation(
    BuildContext context,
    Order order,
  ) {
    return Navigator.pushReplacementNamed(
      context,
      orderConfirmation,
      arguments: order,
    );
  }
}
