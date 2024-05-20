import 'package:econodrive/pages/home.dart';
import 'package:econodrive/pages/my_notices.dart';
import 'package:econodrive/pages/my-vehicles.dart';
import 'package:econodrive/pages/upsert-notice.dart';
import 'package:econodrive/pages/notice-details.dart';
import 'package:econodrive/pages/upsert_vehicle.dart';

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
        "/upsert-notice": (context) => const UpsertNoticePage(),
        "/my-notices": (context) => const MyNotices(),
        "/notice-details": (context) => const NoticeDetailsPage(),
        "/my-vehicles": (context) => const MyVehicles(),
        "/upsert-vehicle": (context) => const UpsertVehiclePage(),
      },
      initialRoute: "/login",
    );
  }
}
