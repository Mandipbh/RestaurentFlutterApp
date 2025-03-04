import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider to store the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Helper function to check if an item matches the search query
bool matchesSearchQuery(String itemName, String query) {
  if (query.isEmpty) return true;
  return itemName.toLowerCase().contains(query.toLowerCase());
}
