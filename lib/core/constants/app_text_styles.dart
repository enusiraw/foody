import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application text style constants
/// Centralized text styling for consistent typography across the app
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Font Family
  static const String fontFamily = 'Roboto';

  // ========== HEADINGS ==========

  /// Large heading - Used for main titles
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: -0.5,
  );

  /// Medium heading - Used for section titles
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: -0.5,
  );

  /// Small heading - Used for card titles
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  /// Extra small heading - Used for subsection titles
  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  /// Tiny heading - Used for labels
  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  // ========== BODY TEXT ==========

  /// Large body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    height: 1.5,
  );

  /// Medium body text - Default body text
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    height: 1.5,
  );

  /// Small body text
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    height: 1.5,
  );

  // ========== BUTTONS ==========

  /// Button text style - Large
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  /// Button text style - Medium
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  /// Button text style - Small
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    letterSpacing: 0.5,
  );

  // ========== CAPTIONS & LABELS ==========

  /// Caption text - Used for hints and helper text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
  );

  /// Label text - Used for form labels
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  /// Overline text - Used for categories/tags
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
    letterSpacing: 1.5,
  );

  // ========== SPECIALIZED STYLES ==========

  /// Price text style
  static const TextStyle price = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.primary,
  );

  /// Price small text style
  static const TextStyle priceSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
    color: AppColors.primary,
  );

  /// Rating text style
  static const TextStyle rating = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  /// App bar title style
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  /// Card title style
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  /// Chip text style
  static const TextStyle chip = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );

  // ========== COLORED TEXT VARIANTS ==========

  /// Primary colored text
  static TextStyle primaryText(TextStyle base) {
    return base.copyWith(color: AppColors.primary);
  }

  /// Secondary colored text
  static TextStyle secondaryText(TextStyle base) {
    return base.copyWith(color: AppColors.textSecondaryLight);
  }

  /// Error colored text
  static TextStyle errorText(TextStyle base) {
    return base.copyWith(color: AppColors.error);
  }

  /// Success colored text
  static TextStyle successText(TextStyle base) {
    return base.copyWith(color: AppColors.success);
  }

  /// White colored text
  static TextStyle whiteText(TextStyle base) {
    return base.copyWith(color: Colors.white);
  }
}
