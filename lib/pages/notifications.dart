import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:econodrive/utils/format-date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  _readNotifications() {
    var notificationsCollectionRef =
        FirebaseFirestore.instance.collection("notifications");
    var user = FirebaseAuth.instance.currentUser;
    var userNotifications = notificationsCollectionRef
        .where("userId", isEqualTo: user!.uid)
        .orderBy("createdAt", descending: true);
    return userNotifications.snapshots();
  }

  _readNotificationVehicle(String vehicleId) {
    var noticesCollectionRef =
        FirebaseFirestore.instance.collection("vehicles");
    return noticesCollectionRef.doc(vehicleId).snapshots();
  }

  _deleteNotification(String notificationId) {
    var notificationsCollectionRef =
        FirebaseFirestore.instance.collection("notifications");
    notificationsCollectionRef.doc(notificationId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: CustomBottomNavigationBar(
          screen: "/notifications",
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Minhas notificações",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<dynamic>(
                    stream: _readNotifications(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return const Text("Nenhuma notificação encontrada");
                      }
                      var notifications = snapshot.data!.docs;
                      return Column(
                        children: notifications.map<Widget>(
                          (notification) {
                            if (notification["type"] == "cancel") {
                              return StreamBuilder<dynamic>(
                                stream: _readNotificationVehicle(
                                    notification["vehicleId"]),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  var vehicle = snapshot.data;

                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                        "Reserva do veículo ${vehicle["name"]} cancelada",
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                      subtitle: Text(
                                        formatStringDateWithTime(
                                          notification["createdAt"],
                                        ),
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            vehicle["image"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          _deleteNotification(notification.id);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            return StreamBuilder<dynamic>(
                                stream: _readNotificationVehicle(
                                    notification["vehicleId"]),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  var vehicle = snapshot.data;

                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                        "Veículo ${vehicle["name"]} reservado",
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                      subtitle: Text(
                                        formatStringDateWithTime(
                                          notification["createdAt"],
                                        ),
                                      ),
                                      leading: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            vehicle["image"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {
                                          _deleteNotification(notification.id);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
