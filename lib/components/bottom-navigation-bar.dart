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

  _readUserNotifications() {
    var notificationsCollectionRef =
        FirebaseFirestore.instance.collection("notifications");
    var user = FirebaseAuth.instance.currentUser;
    var userNotifications = notificationsCollectionRef
        .where("userId", isEqualTo: user!.uid)
        .orderBy("createdAt", descending: true);
    return userNotifications.snapshots();
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
        "label": 'Minhas reservas',
        "icon": const Icon(Icons.calendar_today),
        "route": "/my-reservations",
        "permission": "personal"
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
      {
        "label": 'Notificações',
        "icon": Stack(
          children: [
            const Icon(Icons.notifications),
            Positioned(
              right: 0,
              child: StreamBuilder<QuerySnapshot>(
                stream: _readUserNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  final notificationCount = snapshot.data?.docs.length ?? 0;
                  return notificationCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$notificationCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox();
                },
              ),
            ),
          ],
        ),
        "route": "/notifications",
        "permission": ""
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
