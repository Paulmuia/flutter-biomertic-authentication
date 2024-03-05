import 'package:biometrics_authentication/auth/auth_screen.dart';
import 'package:biometrics_authentication/pages/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      debugShowCheckedModeBanner: false,

      home: AuthScreen(),
    );
  }
}

