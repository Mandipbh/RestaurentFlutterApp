import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/constants/strings.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/authentication/register_screen.dart';
import 'package:restaurent/screens/reserve_table/reserve_table.dart';
import 'package:restaurent/widgets/custom_button.dart';
import 'package:restaurent/widgets/custom_text.dart';
import 'package:restaurent/widgets/custom_textfield.dart';
import 'package:restaurent/widgets/custom_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? selectedCategory;

  const LoginScreen({Key? key, this.selectedCategory}) : super(key: key);

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'kavita@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    final supabase = Supabase.instance.client;

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (response.user != null) {
          final loggedInUser = response.user;
          if (loggedInUser != null) {
            ref.read(authProvider.notifier).state = loggedInUser;
          }
          navigateToNextScreen();
        }
      } catch (e) {
        setState(() {});

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

  void navigateToNextScreen() {
    if (widget.selectedCategory == "ORDER FOOD") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (widget.selectedCategory == "RESERVE TABLE") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReserveTable()),
      );
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
                SizedBox(height: 20),
                CustomText(
                  text: "Selected Category: ${widget.selectedCategory}",
                  fontSize: 16,
                  color: Colors.white,
                ),
                SizedBox(height: 80),
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
                _isLoading
                    ? CircularProgressIndicator()
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
