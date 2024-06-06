import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/utils/format-date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NoticeDetailsPage extends StatelessWidget {
  const NoticeDetailsPage({super.key});

  Stream<QuerySnapshot<Map<String, dynamic>>> _readNoticeVehicle(
      String vehicleId) {
    var vehicles = FirebaseFirestore.instance
        .collection("vehicles")
        .where("id", isEqualTo: vehicleId)
        .snapshots();
    return vehicles;
  }

  _createRentNotification(Map noticeToEdit) async {
    var notificationsCollectionRef =
        FirebaseFirestore.instance.collection("notifications");
    var user = FirebaseAuth.instance.currentUser;
    await notificationsCollectionRef.add({
      "userId": user!.uid,
      "vehicleId": noticeToEdit["vehicleId"],
      "type": "reservation",
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  _createRentNotificationForRentalCompany(Map noticeToEdit) async {
    var notificationsCollectionRef =
        FirebaseFirestore.instance.collection("notifications");
    await notificationsCollectionRef.add({
      "userId": noticeToEdit["createdBy"],
      "vehicleId": noticeToEdit["vehicleId"],
      "type": "reservation",
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  _rentVehicle(BuildContext context) async {
    try {
      final arguments = (ModalRoute.of(context)?.settings.arguments) as Map?;
      Map? noticeToEdit = arguments?["notice"];
      var noticesCollectionRef =
          FirebaseFirestore.instance.collection("notices");
      var user = FirebaseAuth.instance.currentUser;
      await noticesCollectionRef.doc(noticeToEdit!["id"]).update({
        "status": "reserved",
        "rentedById": user!.uid,
        "rentedByName": user.displayName,
        "rentedAt": DateTime.now().toIso8601String(),
      });
      await _createRentNotification(noticeToEdit);
      await _createRentNotificationForRentalCompany(noticeToEdit);
      Navigator.of(context).pop();
      Navigator.pushNamed(
        context,
        "/my-reservations",
      );
    } catch (e) {
      print(e);
    }
  }

  _showRendVehicleModal(BuildContext context, Map notice) {
    showDialog(
      context: context,
      builder: (BuildContext confirmationContext) {
        return AlertDialog(
          title: const Text("Reservar veículo"),
          content: const Text(
            "Deseja reservar o veículo? Você poderá cancelar a reserva na página de 'Minhas reservas'.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                _rentVehicle(context);
              },
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) as Map?;
    Map? notice = arguments?["notice"];
    if (notice == null) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () {
                _showRendVehicleModal(context, notice);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                textStyle: const TextStyle(
                  fontSize: 15,
                ),
              ),
              child: const Text("Reservar agora"),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: StreamBuilder<dynamic>(
              stream: _readNoticeVehicle(notice["vehicleId"]),
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
                    Row(
                      children: [
                        Flexible(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              vehicle["image"],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Text(
                      vehicle["name"],
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      vehicleTypes[vehicle["type"]]!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Origem:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${notice["originCity"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Destino:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${notice["destinyCity"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Data de retirada:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${notice["withdrawDate"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Data de devolução:",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${notice["returnDate"]}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Data da criação do anúncio:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                formatDate(notice["createdAt"]),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Locadora:",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                notice["createdByName"] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Opcionais",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Observações",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          notice["observation"],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
