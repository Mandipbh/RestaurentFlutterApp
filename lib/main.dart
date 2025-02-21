import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent/providers/auth_provider.dart';
import 'package:restaurent/screens/order_food/order_food.dart';
import 'package:restaurent/screens/splash/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://aankyjkbdfbqyijpfvxj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhbmt5amtiZGZicXlpanBmdnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0NDYxNjAsImV4cCI6MjA1NTAyMjE2MH0.pJQPliX_VITJFlDJBBoUFw18oinQbfwsug174icplaA', // Replace with your Supabase anon key
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Supabase Auth',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: 'GillSans', 
  ),
  home: AuthWrapper(),
);
  }
}
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        if (state.session != null) {
          return  OrderFood();
        }
        return  Splash();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
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