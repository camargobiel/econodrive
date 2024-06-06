import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/utils/constants.dart';
import 'package:econodrive/utils/format-date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyReservationCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> reservation;

  Map<String, Color> statusColors = {
    "active": Colors.green,
    "reserved": Colors.blue,
    "inactive": Colors.red,
    "done": Colors.black54,
  };

  Map<String, String> statusNames = {
    "active": "Ativo",
    "reserved": "Reservado",
    "inactive": "Inativo",
    "done": "Encerrado",
  };

  MyReservationCard({
    super.key,
    required this.reservation,
  });

  Stream<QuerySnapshot<Map<String, dynamic>>> _readReservationVehicle() {
    var vehicles = FirebaseFirestore.instance
        .collection("vehicles")
        .where("id", isEqualTo: reservation["vehicleId"])
        .snapshots();
    return vehicles;
  }

  _createCancelRentNotification(
    QueryDocumentSnapshot<Map<String, dynamic>> reservation,
  ) async {
    var notificationsCollectionRef =
        FirebaseFirestore.instance.collection("notifications");
    var user = FirebaseAuth.instance.currentUser;
    await notificationsCollectionRef.add({
      "userId": user!.uid,
      "vehicleId": reservation["vehicleId"],
      "type": "cancel",
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  void _cancelReservation(BuildContext context) async {
    try {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Reserva cancelada com sucesso!',
          ),
          backgroundColor: Colors.red,
        ),
      );
      var noticesCollectionRef =
          FirebaseFirestore.instance.collection("notices");
      await noticesCollectionRef.doc(reservation["id"]).update(
        {
          "status": "active",
          "rentedByName": "",
          "rentedById": "",
          "rentedAt": "",
        },
      );
      await _createCancelRentNotification(reservation);
    } catch (e) {}
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: const Text(
            "Cancelar reserva",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Tem certeza que deseja cancelar essa reserva? Essa ação não poderá ser desfeita.",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Voltar",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _cancelReservation(context);
              },
              child: const Text(
                "Confirmar",
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder<dynamic>(
              stream: _readReservationVehicle(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                var vehicle = snapshot.data!.docs[0];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          tooltip: "Opções",
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              enabled: reservation["status"] != "done",
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: reservation["status"] == "done"
                                        ? Colors.black26
                                        : Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Cancelar reserva',
                                    style: TextStyle(
                                      color: reservation["status"] == "done"
                                          ? Colors.black26
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showCancelConfirmation(context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                            SizedBox(
                              height: 30,
                            ),
                            Icon(
                              Icons.location_on,
                              size: 23,
                              color: Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${reservation["originCity"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Retirada: ${reservation["withdrawDate"]}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${reservation["destinyCity"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Devolução: ${reservation["returnDate"]}",
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
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle["name"],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          vehicleTypes[vehicle["type"]]!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Reservado em: ${formatDate(
                            reservation["rentedAt"],
                          )}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "Status: ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              statusNames[reservation["status"]]!,
                              style: TextStyle(
                                fontSize: 14,
                                color: statusColors[reservation["status"]],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
