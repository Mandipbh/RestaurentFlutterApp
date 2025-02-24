import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  Future<void> fetchReservations() async {
    try {
      final user = ref.read(authProvider);
      final userId = user?.userMetadata?['sub'];

      if (userId == null) return;

      final response = await Supabase.instance.client
          .from('reservation_table')
          .select('restaurant_name, date, time, no_of_people')
          .eq('user_id', userId)
          .order('date', ascending: true);

      state = List<Map<String, dynamic>>.from(response);
    } catch (error) {
      print("Fetch error: $error");
    }
  }
}
