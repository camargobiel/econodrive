import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/format-date.dart';

class MyNoticeCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> notice;

  MyNoticeCard({
    super.key,
    required this.notice,
  });

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

  void _inactivate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Anúncio desativado com sucesso!',
        ),
        backgroundColor: Colors.red,
      ),
    );
    FirebaseFirestore.instance.collection("notices").doc(notice["id"]).update({
      "status": "inactive",
    });
    Navigator.pop(context);
  }

  _activate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Anúncio ativado com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    FirebaseFirestore.instance.collection("notices").doc(notice["id"]).update({
      "status": "active",
    });
  }

  _end(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Anúncio encerrado com sucesso!',
        ),
        backgroundColor: Colors.red,
      ),
    );
    FirebaseFirestore.instance.collection("notices").doc(notice["id"]).update({
      "status": "done",
    });
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

  void _showInactivationConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: const Text(
            "Desativar anúncio",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Tem certeza que deseja desativar esse anúncio? Ele não será mais exibido para outros usuários.",
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
                _inactivate(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red,
                ),
              ),
              child: const Text("Desativar"),
            ),
          ],
        );
      },
    );
  }

  void _showEndConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return AlertDialog(
          title: const Text(
            "Encerrar anúncio",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Tem certeza que deseja encerrar esse anúncio? Ele será finalizado e não poderá ser mais ativado.",
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
                _end(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.red,
                ),
              ),
              child: const Text("Encerrar"),
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
                              enabled: notice["status"] == "active",
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
                            ),
                            PopupMenuItem(
                              enabled: notice["status"] == "active" ||
                                  notice["status"] == "done",
                              onTap: () {
                                _showDeleteConfirmation(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: notice["status"] == "active" ||
                                            notice["status"] == "done"
                                        ? Colors.red
                                        : Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Apagar anúncio',
                                    style: TextStyle(
                                      color: notice["status"] == "active" ||
                                              notice["status"] == "done"
                                          ? Colors.red
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              enabled: notice["status"] == "active",
                              onTap: () {
                                _showInactivationConfirmation(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.remove_circle,
                                    color: notice["status"] == "active"
                                        ? Colors.red
                                        : Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Desativar anúncio',
                                    style: TextStyle(
                                      color: notice["status"] == "active"
                                          ? Colors.red
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              enabled: notice["status"] == "inactive",
                              onTap: () {
                                _activate(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: notice["status"] == "inactive"
                                        ? Colors.green
                                        : Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Ativar anúncio',
                                    style: TextStyle(
                                      color: notice["status"] == "inactive"
                                          ? Colors.green
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              enabled: notice["status"] == "reserved",
                              onTap: () {
                                _showEndConfirmation(context);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.stop_circle,
                                    color: notice["status"] == "reserved"
                                        ? Colors.red
                                        : Colors.black54,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Encerrar anúncio',
                                    style: TextStyle(
                                      color: notice["status"] == "reserved"
                                          ? Colors.red
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
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
                              statusNames[notice["status"]]!,
                              style: TextStyle(
                                fontSize: 14,
                                color: statusColors[notice["status"]],
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
