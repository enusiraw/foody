import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/food_menu/food_menu_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/cart/cart_event.dart';
import 'bloc/order/order_bloc.dart';
import 'repositories/food_repository.dart';
import 'repositories/order_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const FoodyApp());
}

class FoodyApp extends StatelessWidget {
  const FoodyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FoodRepository>(
          create: (context) => FoodRepository(),
        ),
        RepositoryProvider<OrderRepository>(
          create: (context) => OrderRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FoodMenuBloc>(
            create: (context) => FoodMenuBloc(
              foodRepository: context.read<FoodRepository>(),
            ),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc()..add(const LoadCart()),
          ),
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(
              orderRepository: context.read<OrderRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Foody - Food Delivery',
          debugShowCheckedModeBanner: false,
          
          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system, // Follows system theme
          
          // Route configuration
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
      ),
    );
  }
}
