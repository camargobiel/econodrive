import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  String screen = "/home";

  CustomBottomNavigationBar({
    super.key,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttons = [
      {
        "label": 'Página inicial',
        "icon": const Icon(Icons.home),
        "route": "/home",
      },
      {
        "label": 'Meus anúncios',
        "icon": const Icon(Icons.announcement),
        "route": "/my-notices"
      },
    ];

    return BottomNavigationBar(
      currentIndex: buttons.indexWhere((element) => element["route"] == screen),
      items: [
        ...buttons.map((button) {
          return BottomNavigationBarItem(
            icon: button["icon"],
            label: button["label"],
          );
        })
      ],
      onTap: (index) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          buttons[index]["route"],
          (route) => false,
        );
      },
    );
  }
}
