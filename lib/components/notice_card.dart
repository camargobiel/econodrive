import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NoticeCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> notice;

  const NoticeCard({
    super.key,
    required this.notice,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> _readNoticeVehicle() {
    var vehicles = FirebaseFirestore.instance
        .collection("vehicles")
        .where("id", isEqualTo: notice["vehicleId"])
        .snapshots();
    return vehicles;
  }

  _readUser() {
    var authUser = FirebaseAuth.instance.currentUser;
    var user =
        FirebaseFirestore.instance.collection("users").doc(authUser!.uid);
    return user.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder<dynamic>(
            stream: _readNoticeVehicle(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.data!.docs.isEmpty) {
                return Container();
              }
              var vehicle = snapshot.data!.docs[0];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 23,
                            color: Colors.red,
                          ),
                          SizedBox(height: 30),
                          Icon(
                            Icons.location_on,
                            size: 23,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${notice["originCity"]}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Retirada: ${notice["withdrawDate"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${notice["destinyCity"]}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Devolução: ${notice["returnDate"]}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          vehicle["image"],
                          width: 200,
                        ),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle["name"],
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        vehicleTypes[vehicle["type"]]!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.from(
                          vehicle["optionals"]
                              .where((optional) => optional["value"] == true)
                              .map<Widget>(
                            (optional) {
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.black54,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        optional["label"],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const Spacer(), // Pushes the button to the bottom
                  StreamBuilder<dynamic>(
                      stream: _readUser(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        var user = snapshot.data;
                        if (user["type"] == "rental") {
                          return Container();
                        }

                        return ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/notice-details",
                              arguments: {
                                "notice": notice.data(),
                              },
                            );
                          },
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                              const Size(
                                double.maxFinite,
                                40,
                              ),
                            ),
                          ),
                          child: const Text("RESERVAR AGORA"),
                        );
                      }),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
