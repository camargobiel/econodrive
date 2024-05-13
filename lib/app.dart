import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:econodrive/pages/home.dart';
import 'package:econodrive/pages/my-notices.dart';
import 'package:econodrive/pages/new-notice.dart';
import 'package:econodrive/pages/notice-details.dart';

import 'pages/login.dart';
import 'pages/register.dart';
import 'package:flutter/material.dart';

class EconoDrive extends StatelessWidget {
  const EconoDrive({super.key});

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
        "/home": (context) => const Home(),
        "/new-notice": (context) => const NewNoticePage(),
        "/my-notices": (context) => const MyNotices(),
        "/notice-details": (context) => const NoticeDetailsPage()
      },
      initialRoute: "/login",
    );
  }
}
