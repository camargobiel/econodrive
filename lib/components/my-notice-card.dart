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

  _delete(context) {
    FirebaseFirestore.instance.collection("notices").doc(notice["id"]).delete();
    Navigator.pop(context);
  }

  _showDeleteConfirmation(BuildContext context) {
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
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.white,
                ),
                fixedSize: MaterialStateProperty.all(
                  const Size(100, 40),
                ),
              ),
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
                fixedSize: MaterialStateProperty.all(
                  const Size(100, 40),
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
        width: 400,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notice["originCity"],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 17,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    notice["destinyCity"],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notice["withdrawDate"],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 17,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    notice["returnDate"],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      "https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/141125/kwid-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80",
                      width: 170,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice["vehicleName"],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        vehicleTypes[notice["vehicleType"]]!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Criado em: ${formatDate(notice["createdAt"])}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/new-notice",
                          arguments: {'notice': notice.data()},
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue,
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                          Size(
                            double.maxFinite,
                            40,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_rounded),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Editar anúncio"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () {
                        _showDeleteConfirmation(context);
                      },
                      style: const ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                          Size(
                            double.maxFinite,
                            40,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Excluir anúncio"),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
