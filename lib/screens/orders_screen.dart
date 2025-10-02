import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';
import '../core/widgets/empty_state.dart';

/// Orders screen - displays user's order history
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        automaticallyImplyLeading: false,
      ),
      body: _buildOrdersList(isDark),
    );
  }

  Widget _buildOrdersList(bool isDark) {
    // Mock empty state - in real app, this would show actual orders
    return const EmptyState(
      emoji: '📦',
      title: 'No Orders Yet',
      subtitle: 'Your order history will appear here',
    );
  }
}
