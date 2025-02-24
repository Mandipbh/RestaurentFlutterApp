import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
final supabase = Supabase.instance.client;

final userProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<UserModel?> {
  AuthNotifier() : super(null) {
    loadUser();
  }

  Future<void> loadUser() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .single();

      if (response != null) {
        state = UserModel.fromMap(response);
      }
    }
  }

  void signOut() async {
    await supabase.auth.signOut();
    state = null;
  }
}