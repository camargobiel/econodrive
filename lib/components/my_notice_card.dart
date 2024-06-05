import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/format-date.dart';

class MyNoticeCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> notice;

  const MyNoticeCard({
    super.key,
    required this.notice,
  });

  void _delete(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Anúncio excluído com sucesso!',
        ),
        backgroundColor: Colors.red,
      ),
    );
    FirebaseFirestore.instance.collection("notices").doc(notice["id"]).delete();
    Navigator.pop(context);
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: const Text(
            "Excluir anúncio",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Tem certeza que deseja excluir esse anúncio? Ele será excluído para sempre.",
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
                "Cancelar",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _delete(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red,
                ),
              ),
              child: const Text("Excluir"),
            ),
          ],
        );
      },
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _readNoticeVehicle() {
    var vehicles = FirebaseFirestore.instance
        .collection("vehicles")
        .where("id", isEqualTo: notice["vehicleId"])
        .snapshots();
    return vehicles;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder<dynamic>(
              stream: _readNoticeVehicle(),
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          tooltip: "Opções",
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_note,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Editar anúncio'),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  "/upsert-notice",
                                  arguments: {
                                    "notice": notice.data(),
                                    "edit": true,
                                  },
                                );
                              },
                            ),
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Apagar anúncio',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showDeleteConfirmation(context);
                              },
                            ),
                          ],
                        ),
                      ],
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
                              "${notice["originCity"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Retirada: ${notice["withdrawDate"]}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${notice["destinyCity"]}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
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
                          "Criado em: ${formatDate(notice["createdAt"])}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
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
