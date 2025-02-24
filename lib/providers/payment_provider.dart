import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/payment_model.dart' show PaymentModel;
import 'package:restaurent/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final paymentProvider = FutureProvider<List<PaymentModel>>((ref) async {
  final supabase = Supabase.instance.client;
  final user = ref.watch(authProvider);

  if (user == null) return [];

  final response = await supabase
      .from('payments') // Replace with your table name
      .select()
      .eq('user_id', user.id) // Assuming there's a 'user_id' field
      .order('created_at', ascending: false);

  return response.map<PaymentModel>((json) => PaymentModel.fromJson(json)).toList();
});