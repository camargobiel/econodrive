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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${notice["originCity"]} → ${notice["destinyCity"]}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  PopupMenuButton(
                    tooltip: "Opções",
                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
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
                            "/new-notice",
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "${notice["withdrawDate"]} - ${notice["returnDate"]}",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      "https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/141125/kwid-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80",
                      width: 170,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notice["vehicleName"],
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          vehicleTypes[notice["vehicleType"]]!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Criado em: ${formatDate(notice["createdAt"])}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
