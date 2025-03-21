import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:restaurent/constants/const.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/navigation/main-navigation.dart';
import 'package:restaurent/screens/onboarding/onboarding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://aankyjkbdfbqyijpfvxj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhbmt5amtiZGZicXlpanBmdnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0NDYxNjAsImV4cCI6MjA1NTAyMjE2MH0.pJQPliX_VITJFlDJBBoUFw18oinQbfwsug174icplaA', // Replace with your Supabase anon key
  
  
  
  
  );
  await _setup();

  runApp(ProviderScope(child: MyApp()));
}
Future<void> _setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishKey;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        primarySwatch: Colors.orange,
        fontFamily: 'GillSans',
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: WillPopScope(
        onWillPop: () async {
return await showExitConfirmationDialog(context);  
        },
        child: AuthWrapper(),
      ),
    );
  }
  
  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Exit'),
            ),
          ],
        );
      },
    ) ?? false;
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        if (state.session != null && state.session?.user != null) {
          return  MainNavigation();
        }
        return  OnboardingScreen();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.orange,),
        ),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}