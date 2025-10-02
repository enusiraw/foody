import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foody/bloc/food_menu/food_menu_bloc.dart';
import 'package:foody/bloc/food_menu/food_menu_event.dart';
import 'package:foody/bloc/food_menu/food_menu_state.dart';
import 'package:foody/repositories/food_repository.dart';

void main() {
  group('FoodMenuBloc', () {
    late FoodMenuBloc foodMenuBloc;
    late FoodRepository foodRepository;

    setUp(() {
      foodRepository = FoodRepository();
      foodMenuBloc = FoodMenuBloc(foodRepository: foodRepository);
    });

    tearDown(() {
      foodMenuBloc.close();
    });

    test('initial state is FoodMenuInitial', () {
      expect(foodMenuBloc.state, equals(const FoodMenuInitial()));
    });

    blocTest<FoodMenuBloc, FoodMenuState>(
      'emits [FoodMenuLoading, FoodMenuLoaded] when LoadFoodMenu is added',
      build: () => foodMenuBloc,
      act: (bloc) => bloc.add(const LoadFoodMenu()),
      expect: () => [
        const FoodMenuLoading(),
        isA<FoodMenuLoaded>()
            .having((state) => state.foodItems.isNotEmpty, 'has items', true)
            .having((state) => state.availableCategories.isNotEmpty,
                'has categories', true),
      ],
    );

    blocTest<FoodMenuBloc, FoodMenuState>(
      'emits filtered items when FilterByCategory is added',
      build: () => foodMenuBloc,
      seed: () => const FoodMenuLoaded(
        foodItems: [],
        availableCategories: ['Burgers', 'Pizza'],
      ),
      act: (bloc) => bloc.add(const FilterByCategory('Burgers')),
      expect: () => [
        const FoodMenuLoading(),
        isA<FoodMenuLoaded>()
            .having((state) => state.selectedCategory, 'selected category',
                'Burgers')
            .having(
                (state) => state.foodItems
                    .every((item) => item.category == 'Burgers'),
                'all items are burgers',
                true),
      ],
    );

    blocTest<FoodMenuBloc, FoodMenuState>(
      'emits searched items when SearchFood is added',
      build: () => foodMenuBloc,
      act: (bloc) async {
        // First load the menu
        bloc.add(const LoadFoodMenu());
        await Future.delayed(const Duration(milliseconds: 600));
        // Then search
        bloc.add(const SearchFood('burger'));
      },
      skip: 2, // Skip loading and initial loaded state
      expect: () => [
        isA<FoodMenuLoaded>().having(
          (state) => state.foodItems
              .every((item) => item.name.toLowerCase().contains('burger')),
          'all items contain burger',
          true,
        ),
      ],
    );

    blocTest<FoodMenuBloc, FoodMenuState>(
      'refreshes menu when RefreshMenu is added',
      build: () => foodMenuBloc,
      seed: () => const FoodMenuLoaded(
        foodItems: [],
        availableCategories: [],
      ),
      act: (bloc) => bloc.add(const RefreshMenu()),
      expect: () => [
        isA<FoodMenuLoaded>()
            .having((state) => state.foodItems.isNotEmpty, 'has items', true),
      ],
    );
  });
}
