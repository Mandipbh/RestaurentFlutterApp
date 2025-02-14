import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatelessWidget {
  final _supabase = Supabase.instance.client;

  // ✅ Logout
  Future<void> logout() async {
    await _supabase.auth.signOut();
    print('Logged out successfully');
  }

  @override
  Widget build(BuildContext context) {
    final user = _supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            logout();
            Navigator.pop(context);
          },
        )
      ]),
      body: Center(
        child: Text('Welcome, ${user?.phone ?? 'User'}!'),
      ),
    );
  }
}
