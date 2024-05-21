import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: CustomBottomNavigationBar(
        screen: "/profile",
      ),
    );
  }
}
