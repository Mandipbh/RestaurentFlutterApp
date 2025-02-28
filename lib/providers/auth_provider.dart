import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final authProvider = StateProvider<User?>((ref) {
  return supabase.auth.currentUser;
});

void printUserDetails(WidgetRef ref) {
  final user = ref.read(authProvider);

  if (user != null) {
    print('User ID: ${user.id}');
    print('Email: ${user.email}');
    print('Created At: ${user.createdAt}');
    print('Last Sign-in: ${user.lastSignInAt}');
  } else {
    print('No user is logged in.');
  }
}

final authStateProvider = StreamProvider<AuthState>((ref) {
  return supabase.auth.onAuthStateChange;
});

