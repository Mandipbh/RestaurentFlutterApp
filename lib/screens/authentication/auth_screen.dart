import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/screens/authentication/login.screen.dart';
import 'package:restaurent/widgets/custom_button.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:restaurent/widgets/custom_textfield.dart';
import 'package:restaurent/widgets/custom_toast.dart';
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
        await insertUserData(response.user!.id, _nameController.text,
            _emailController.text, _phoneController.text);
        FlushbarUtils.showSuccessFlushbar(context, Strings.signupsuccess);
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _phoneController.clear();
      }
    } catch (e) {
      print('Error: $e');
      FlushbarUtils.showErrorFlushbar(context, Strings.signinerrortext);
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

  Future<void> insertUserData(
      String userId, String fullName, String email, String phone) async {
    try {
      await supabase.from('users').insert({
        'id': userId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'address': '',
        'profile_pic':
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6V99HAvYPLbG2hkKh5QK9aGnRmvwaWhc132y9Q0Rf_B2Wmy2R-OHr_sk&s',
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
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),
              Column(
                children: [
                  CustomText(
                    text: Strings.signupText,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  CustomText(
                    text: Strings.signupDesc,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 80),
              CustomTextField(
                nameController: _nameController,
                labelText: Strings.fullname,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  if (value.length < 3) {
                    return "Name must be at least 3 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              CustomTextField(
                nameController: _emailController,
                labelText: Strings.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              CustomTextField(
                nameController: _phoneController,
                labelText: Strings.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  final phoneRegex = RegExp(r'^\d{10}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return "Enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),
              SizedBox(height: 25),
              CustomTextField(
                nameController: _passwordController,
                labelText: Strings.password,
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 90),
              CustomButton(
                onPressed: signUp,
                text: Strings.signin,
              ),
              SizedBox(height: 130),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: Strings.haveaccount,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 5),
                    CustomText(
                      text: Strings.loginText,
                      fontSize: 16,
                      color: Color.fromARGB(255, 163, 16, 16),
                      onTap: () {
                        login();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
