import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  String screen = "/home";

  CustomBottomNavigationBar({
    super.key,
    required this.screen,
  });

  _readUser() {
    var user = FirebaseAuth.instance.currentUser;
    var account = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    return account.snapshots();
  }

  _filterButtons(List<Map<String, dynamic>> buttons, dynamic snapshot) {
    return buttons.where(
      (element) {
        return element["permission"] == ""
            ? true
            : element["permission"] == snapshot.data?["type"];
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttons = [
      {
        "label": 'Home',
        "icon": const Icon(Icons.home),
        "route": "/home",
        "permission": ""
      },
      {
        "label": 'Notificações',
        "icon": const Icon(Icons.notifications),
        "route": "/home",
        "permission": ""
      },
      {
        "label": 'Anúncios',
        "icon": const Icon(Icons.announcement),
        "route": "/my-notices",
        "permission": "rental"
      },
      {
        "label": 'Veículos',
        "icon": const Icon(Icons.car_rental),
        "route": "/my-vehicles",
        "permission": "rental"
      },
    ];

    return StreamBuilder<dynamic>(
        stream: _readUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          List<dynamic> filteredButtons = _filterButtons(buttons, snapshot);
          int currentIndex = filteredButtons.indexWhere(
            (element) => element["route"] == screen,
          );
          int correctedCurrentIndex = currentIndex == -1 ? 0 : currentIndex;

          return BottomNavigationBar(
            currentIndex: correctedCurrentIndex,
            type: BottomNavigationBarType.fixed,
            items: filteredButtons.map((button) {
              return BottomNavigationBarItem(
                icon: button["icon"],
                label: button["label"],
              );
            }).toList(),
            onTap: (index) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                filteredButtons[index]["route"],
                (route) => false,
              );
            },
          );
        });
  }
}
