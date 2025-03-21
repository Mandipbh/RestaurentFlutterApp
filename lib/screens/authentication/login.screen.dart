import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/authentication/register_screen.dart';
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/widgets/custom_button.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:restaurent/widgets/custom_textfield.dart';
import 'package:restaurent/widgets/custom_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'kavita@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Future<void> _loginUser() async {
    // final supabase = Supabase.instance.client;

    // if (_formKey.currentState!.validate()) {
      // setState(() {
        // _isLoading = true;
      // });

      // try {
        // final response = await supabase.auth.signInWithPassword(
          // email: _emailController.text.trim(),
          // password: _passwordController.text.trim(),
        // );

        // if (response.user != null) {
          // final loggedInUser = response.user;
          // if (loggedInUser != null) {
            // ref.read(authProvider.notifier).state = loggedInUser;
            // 
            // Ensure Supabase session is initialized before navigating
            // await supabase.auth.refreshSession();
          // final session = supabase.auth.currentSession;
            // if (session == null) {
              // throw Exception("Session initialization failed.");
            // }
          // }

          // Navigator.pushReplacement(
            // context,
            // MaterialPageRoute(builder: (context) => MainNavigation()),
          // );
        // }
      // } catch (e) {
        // print("Login error: $e");

        // FlushbarUtils.showErrorFlushbar(
          // context,
          // Strings.loginerrortext,
        // );
      // } finally {
        // setState(() {
          // _isLoading = false;
        // });
      // }
    // }
  // }
Future<void> _loginUser() async {
  final supabase = Supabase.instance.client;

  if (_formKey.currentState!.validate()) {
    // Close the keyboard before login process starts
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });

    try {
      // 1️⃣ Sign in user
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        // 2️⃣ Wait for Supabase to update the session
        await Future.delayed(Duration(seconds: 1));

        // 3️⃣ Force refresh session
        await supabase.auth.refreshSession();

        // 4️⃣ Get the latest session to ensure correct user data
        final session = supabase.auth.currentSession;
        if (session == null) {
          throw Exception("Session initialization failed.");
        }




        // 5️⃣ Update Riverpod provider with the correct user
        ref.read(authProvider.notifier).state = session.user;

        // 6️⃣ Navigate to MainNavigation with the correct user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigation()),
        );
      }
    } catch (e) {
      print("Login error: $e");

      FlushbarUtils.showErrorFlushbar(
        context,
        "Login failed. Please try again.",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                CustomText(
                  text: Strings.welcomtext,
                  fontSize: 30,
                  color: Colors.white,
                ),
                CustomText(
                  text: Strings.welcomdesc,
                  fontSize: 14,
                  color: Colors.white,
                ),
                SizedBox(height: 100),
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
                  nameController: _passwordController,
                  labelText: Strings.password,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (!RegExp(
                            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                        .hasMatch(value)) {
                      return "Password must be at least 8 characters, include an uppercase letter, lowercase letter, number, and special character.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator(color: Colors.orange,)
                    : CustomButton(
                        onPressed: _loginUser,
                        text: Strings.loginText,
                      ),
                SizedBox(height: 40),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        text: Strings.dontaccount,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      CustomText(
                        text: Strings.signin,
                        fontSize: 16,
                        color: Color.fromARGB(255, 163, 16, 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
