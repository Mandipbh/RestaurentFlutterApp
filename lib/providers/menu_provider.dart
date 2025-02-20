import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseProvider = Provider((ref) => Supabase.instance.client);

final menuCategoriesProvider = FutureProvider((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase.from('menu_categories').select();
  return response;
});

final breakfastItemsProvider = FutureProvider((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase
      .from('combination_breakfast')
      .select('*, menu_categories(name)');
  return response;
});


final recommendedBreakfastsProvider = FutureProvider((ref) async {
  final supabase = ref.read(supabaseProvider);
  final response = await supabase
      .from('recommended_breakfast').select();
  return response;
});