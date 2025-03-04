import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/order_model.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final orderProvider = FutureProvider<List<OrderModel>>((ref) async {
    final user = ref.watch(authProvider);

  final response = await supabase
      .from('orders')
      .select()
            .eq('user_id', user!.id) // Assuming there's a 'user_id' field

      .order('created_at', ascending: false);

  return response.map<OrderModel>((json) => OrderModel.fromJson(json)).toList();
});