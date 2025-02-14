import 'package:flutter/material.dart';
import 'package:restaurent/screens/authentication/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://aankyjkbdfbqyijpfvxj.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFhbmt5amtiZGZicXlpanBmdnhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0NDYxNjAsImV4cCI6MjA1NTAyMjE2MH0.pJQPliX_VITJFlDJBBoUFw18oinQbfwsug174icplaA', // Replace with your Supabase anon key
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AuthScreen(),
    );
  }
}
