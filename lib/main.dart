import 'package:flutter/material.dart';

import 'pages/login.dart';
import 'pages/register.dart';

void main() {
  runApp(const EconoDrive());
}

class EconoDrive extends StatelessWidget {
  const EconoDrive({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primarySwatch: Colors.red,
      ),
      routes: {
        "/login": (context) => const LoginPage(),
        "/register": (context) => const RegisterPage(),
      },
      initialRoute: "/login",
    );
  }
}
