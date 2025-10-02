import 'package:flutter/material.dart';

/// Application color constants
/// Centralized color management for consistent theming across the app
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFFF57C00); // Orange 700
  static const Color primaryLight = Color(0xFFFFB74D); // Orange 300
  static const Color primaryDark = Color(0xFFE65100); // Orange 900

  // Secondary Colors
  static const Color secondary = Color(0xFFFF9800); // Orange 500
  static const Color secondaryLight = Color(0xFFFFCC80); // Orange 200
  static const Color secondaryDark = Color(0xFFF57C00); // Orange 700

  // Background Colors - Light Theme
  static const Color backgroundLight = Color(0xFFFAFAFA); // Grey 50
  static const Color surfaceLight = Color(0xFFFFFFFF); // White
  static const Color cardLight = Color(0xFFFFFFFF); // White

  // Background Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF121212); // Dark Grey
  static const Color surfaceDark = Color(0xFF1E1E1E); // Slightly lighter dark
  static const Color cardDark = Color(0xFF2C2C2C); // Card background dark

  // Text Colors - Light Theme
  static const Color textPrimaryLight = Color(0xFF212121); // Grey 900
  static const Color textSecondaryLight = Color(0xFF757575); // Grey 600
  static const Color textDisabledLight = Color(0xFFBDBDBD); // Grey 400

  // Text Colors - Dark Theme
  static const Color textPrimaryDark = Color(0xFFFFFFFF); // White
  static const Color textSecondaryDark = Color(0xFFB0BEC5); // Blue Grey 200
  static const Color textDisabledDark = Color(0xFF616161); // Grey 700

  // Accent Colors
  static const Color success = Color(0xFF4CAF50); // Green 500
  static const Color error = Color(0xFFF44336); // Red 500
  static const Color warning = Color(0xFFFF9800); // Orange 500
  static const Color info = Color(0xFF2196F3); // Blue 500

  // Rating & Status Colors
  static const Color rating = Color(0xFFFFC107); // Amber 500
  static const Color available = Color(0xFF4CAF50); // Green 500
  static const Color unavailable = Color(0xFF9E9E9E); // Grey 500

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFFFFB74D), // Orange 300
    Color(0xFFFFE0B2), // Orange 100
  ];

  static const List<Color> cardGradient = [
    Color(0xFFFFB74D), // Orange 300
    Color(0xFFFFE0B2), // Orange 100
  ];

  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0); // Grey 300
  static const Color borderDark = Color(0xFF424242); // Grey 800

  // Divider Colors
  static const Color dividerLight = Color(0xFFBDBDBD); // Grey 400
  static const Color dividerDark = Color(0xFF424242); // Grey 800

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowDark = Colors.black.withOpacity(0.3);

  // Category Colors (for visual distinction)
  static const Map<String, Color> categoryColors = {
    'Burgers': Color(0xFFFF5722), // Deep Orange
    'Pizza': Color(0xFFF44336), // Red
    'Sushi': Color(0xFF009688), // Teal
    'Desserts': Color(0xFFE91E63), // Pink
    'Drinks': Color(0xFF2196F3), // Blue
  };

  // Icon Background Colors
  static const Color iconBackgroundLight = Color(0xFFFFF3E0); // Orange 50
  static const Color iconBackgroundDark = Color(0xFF3E2723); // Brown 900

  // Special UI Element Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  /// Get color by category name
  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? primary;
  }
}
