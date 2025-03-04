import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/providers/search_provider.dart';

class SearchResultsCounter extends ConsumerWidget {
  final AsyncValue foodItems;
  final AsyncValue breakfastItems;
  final AsyncValue recommendedItems;

  const SearchResultsCounter({
    super.key,
    required this.foodItems,
    required this.breakfastItems,
    required this.recommendedItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    
    if (searchQuery.isEmpty) {
      return SizedBox.shrink();
    }

    int totalResults = 0;

    foodItems.maybeWhen(
      data: (foods) {
        if (foods != null) {
          totalResults += foods
              .where((food) => matchesSearchQuery(food['name'] ?? '', searchQuery))
              .length as int;
        }
      },
      orElse: () {},
    );

    breakfastItems.maybeWhen(
      data: (foods) {
        if (foods != null) {
          totalResults += foods
              .where((food) => matchesSearchQuery(food['name'] ?? '', searchQuery))
              .length as int; 
        }
      },
      orElse: () {},
    );

    recommendedItems.maybeWhen(
      data: (foods) {
        if (foods != null) {
          totalResults += foods
              .where((food) => matchesSearchQuery(food['name'] ?? '', searchQuery))
              .length as int; 
        }
      },
      orElse: () {},
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        'Found $totalResults results for "$searchQuery"',
        style: TextStyle(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}