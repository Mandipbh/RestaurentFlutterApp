import 'package:restaurent/model/food_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  final supabase = Supabase.instance.client;

  Future<List<FoodItem>> fetchFoodItems() async {
    final response = await supabase.from('food_items').select('*');
    return response.map((data) => FoodItem.fromJson(data)).toList();
  }
}
