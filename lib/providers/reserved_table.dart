import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final reservationsProvider =
    StateNotifierProvider<ReservationsNotifier, List<Map<String, dynamic>>>(
        (ref) => ReservationsNotifier(ref));

class ReservationsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final Ref ref;

  ReservationsNotifier(this.ref) : super([]) {
    fetchReservations();
  }

  /// Fetch reservations from Supabase
  Future<void> fetchReservations() async {
    try {
      final user = ref.read(authProvider);
      final userId = user?.userMetadata?['sub'];

      if (userId == null) return;

      final response = await Supabase.instance.client
          .from('reservation_table')
          .select(
              'restaurant_id, restaurant_name, date, time, no_of_people, table_no, city_name')
          .eq('user_id', userId)
          .order('date', ascending: true);

      state = List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Fetch error: $error");
    }
  }

  /// Reserve a table and update the state
  Future<void> reserveTable({
    required String? cityName,
    required String? restaurantId,
    required String? restaurantName,
    required DateTime? date,
    required String? time,
    required int? peopleCount,
    required List<int>? selectedTableId,
    required bool? isMerge,
  }) async {
    try {
      final user = ref.read(authProvider);
      final userMetadata = user?.userMetadata;
      final userId = userMetadata?['sub'];
      final userName = userMetadata?['full_name'];

      if (userId == null || userName == null) {
        throw Exception("User not logged in");
      }

      // Format date properly
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());

      // Insert reservation into Supabase
      await Supabase.instance.client.from('reservation_table').insert({
        'city_name': cityName,
        'restaurant_id': restaurantId,
        'restaurant_name': restaurantName,
        'user_id': userId,
        'user_name': userName,
        'date': formattedDate,
        'time': time,
        'no_of_people': peopleCount,
        'table_no': selectedTableId,
        'ismerge': isMerge,
      });

      // Fetch updated reservations
      fetchReservations();
    } catch (error) {
      print("Reservation error: $error");
    }
  }

  /// Check if a reservation exists for the given date and time
  Future<bool> doesReservationExist(
    String restaurantId,
    DateTime date,
    String time,
  ) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final response = await Supabase.instance.client
          .from('reservation_table')
          .select('id')
          .eq('restaurant_id', restaurantId)
          .eq('date', formattedDate)
          .eq('time', time);

      return response.isNotEmpty;
    } catch (error) {
      print("Check reservation error: $error");
      return false;
    }
  }

  Future<void> deleteReservation(String restaurantId) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase
          .from('reservation_table')
          .delete()
          .match({'restaurant_id': restaurantId});

      print("Reservation deleted successfully");

      /// ✅ **Fetch the updated list after deleting**
      await fetchReservations();
    } catch (e) {
      print("Error deleting reservation: $e");
    }
  }
}
