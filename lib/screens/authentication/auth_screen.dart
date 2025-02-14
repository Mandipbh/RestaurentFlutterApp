import 'package:flutter/material.dart';
import 'package:restaurent/screens/authentication/login.screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
    final _phoneController = TextEditingController();

  final supabase = Supabase.instance.client;

  Future<void> signUp() async {
    try {
      final response = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {'full_name': _nameController.text},
      );

      if (response.user != null) {
        print('User registered: ${response.user!.email}');
        await insertUserData(response.user!.id, _nameController.text, _emailController.text, _phoneController.text);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> login() async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
     
    // try {
    //   final response = await supabase.auth.signInWithPassword(
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //   );

    //   if (response.user != null) {
    //     print('User logged in: ${response.user!.email}');
    //   }
    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  Future<void> insertUserData(String userId, String fullName, String email, String phone) async {
    try {
      await supabase.from('users').insert({
        'id': userId,
        'full_name': fullName,
        'email': email,
        'phone':phone,
        'address':'',
        'profile_pic':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6V99HAvYPLbG2hkKh5QK9aGnRmvwaWhc132y9Q0Rf_B2Wmy2R-OHr_sk&s',
        'created_at': DateTime.now().toIso8601String(),
      });
      print('User data inserted successfully');
    } catch (e) {
      print('Error inserting user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Supabase Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Full Name')),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
                        TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone Number')),

            SizedBox(height: 20),
            ElevatedButton(onPressed: signUp, child: Text('Sign Up')),
            ElevatedButton(onPressed: login, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}