import 'package:flutter/material.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/screens/authentication/auth_screen.dart';
import 'package:restaurent/widgets/custom_button.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:restaurent/widgets/custom_textfield.dart';
import 'package:restaurent/widgets/custom_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _errorMessage = '';

  // Future<void> _loginUser() async {
  //   final supabase = Supabase.instance.client;

  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //       _errorMessage = '';
  //     });

  //     try {
  //       final response = await supabase.auth.signInWithPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );

  //       if (response.user != null) {

  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomeScreen()),
  //         );
  //       }
  //     } catch (e) {
  //       setState(() {
  //         _errorMessage = 'Login failed. Please check your credentials. $e';
  //       });
  //     } finally {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  Future<void> _loginUser() async {
    final supabase = Supabase.instance.client;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final response = await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Login failed. Please check your credentials.';
        });

        FlushbarUtils.showErrorFlushbar(
          context,
          Strings.loginerrortext,
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
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 210),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: _loginUser,
                        text: Strings.login,
                      ),
                SizedBox(height: 130),
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
