import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/city.dart';
import 'package:restaurent/model/restaurants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// Supabase instance
final supabase = Supabase.instance.client;

// Fetch Cities
final cityProvider = FutureProvider<List<City>>((ref) async {
  final response = await supabase.from('cities').select();
  return response.map((json) => City.fromJson(json)).toList();
});

// Selected City Provider
final selectedCityProvider = StateProvider<City?>((ref) => null);

// Fetch Restaurants based on selected city
final restaurantProvider = FutureProvider.autoDispose<List<Restaurant>>((ref) async {
  final selectedCity = ref.watch(selectedCityProvider);
  if (selectedCity == null) return [];

  final response = await supabase
      .from('restaurants')
      .select()
      .eq('city_id', selectedCity.id);

  return response.map((json) => Restaurant.fromJson(json)).toList();
});