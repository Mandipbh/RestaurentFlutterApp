import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/city.dart';
import 'package:restaurent/model/restaurants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase instance
final supabase = Supabase.instance.client;
final selectedCityProvider = StateProvider<String?>((ref) => null);

final cityProvider = FutureProvider<List<City>>((ref) async {
  final response = await Supabase.instance.client.from('cities').select();

  if (response.isEmpty) {
    return [];
  }

  return response.map<City>((city) => City.fromJson(city)).toList();
});

final restaurantListProvider =
    FutureProvider.family<List<Restaurant>, String?>((ref, cityId) async {
  if (cityId == null) return [];

  final response = await Supabase.instance.client
      .from('restaurants')
      .select()
      .eq('city_id', cityId);

  return response.map<Restaurant>((json) => Restaurant.fromJson(json)).toList();
});

final selectedCityIdProvider = StateProvider<String?>((ref) => null);
