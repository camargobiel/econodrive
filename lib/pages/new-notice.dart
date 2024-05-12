import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/select-city.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NewNoticePage extends StatefulWidget {
  const NewNoticePage({
    super.key,
    Map<String, dynamic>? notice,
  });

  @override
  State<NewNoticePage> createState() => _NewNoticePageState();
}

class _NewNoticePageState extends State<NewNoticePage> {
  final firestore = FirebaseFirestore.instance;

  Map<String, dynamic> fields = {
    'originCity': "",
    "destinyCity": "",
    "withdrawDate": "",
    "returnDate": "",
    "vehicleName": "",
    "vehicleType": ""
  };

  chooseCity(String field) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SelectCity(
          onCitySelected: (city) {
            setState(() {
              fields[field] = city;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  _create(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;
    var noticesCollectionRef = FirebaseFirestore.instance.collection("notices");
    var docRef = await noticesCollectionRef.add(
      {
        ...fields,
        "createdBy": user!.uid,
        "createdAt": DateTime.now().toIso8601String(),
      },
    );
    var noticeId = docRef.id;
    await docRef.update({
      "id": noticeId,
    });
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/home",
      (route) => false,
    );
  }

  _edit(BuildContext context, Map noticeToEdit) async {
    var noticesCollectionRef = FirebaseFirestore.instance.collection("notices");
    await noticesCollectionRef.doc(noticeToEdit["id"]).update(
      {
        ...fields,
      },
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/my-notices",
      (route) => false,
    );
  }

  submit(BuildContext context, Map? noticeToEdit) async {
    try {
      if (noticeToEdit != null) {
        await _edit(context, noticeToEdit);
        return;
      }
      await _create(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments) as Map?;
    Map? noticeToEdit = arguments?["notice"];
    final formKey = GlobalKey<FormState>();

    fields = {
      'originCity': noticeToEdit?["originCity"] ?? "",
      "destinyCity": noticeToEdit?["destinyCity"] ?? "",
      "withdrawDate": noticeToEdit?["withdrawDate"] ?? "",
      "returnDate": noticeToEdit?["returnDate"] ?? "",
      "vehicleName": noticeToEdit?["vehicleName"] ?? "",
      "vehicleType": noticeToEdit?["vehicleType"] ?? "compactHatch"
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo anúncio"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {
                              chooseCity("originCity");
                            },
                            style: const ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(
                                Size.fromHeight(40),
                              ),
                            ),
                            child: Text(
                              fields["originCity"] == ""
                                  ? "Selecionar cidade de origem"
                                  : "Origem: ${fields["originCity"]}",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Icon(
                        Icons.arrow_circle_right,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: SizedBox(
                          width: double.maxFinite,
                          child: ElevatedButton(
                            onPressed: () {
                              chooseCity("destinyCity");
                            },
                            style: const ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(
                                Size.fromHeight(40),
                              ),
                            ),
                            child: Text(
                              fields["destinyCity"] == ""
                                  ? "Selecionar cidade de destino"
                                  : "Destino: ${fields["destinyCity"]}",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TextFormField(
                          initialValue: fields["withdrawDate"],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Data de retirada"),
                          ),
                          onChanged: (value) {
                            fields["withdrawDate"] = value;
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Campo obrigatório";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: TextFormField(
                          initialValue: fields["returnDate"],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Data de devolução"),
                          ),
                          onChanged: (value) {
                            fields["returnDate"] = value;
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Campo obrigatório";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: fields["vehicleName"],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Nome do veículo"),
                    ),
                    onChanged: (value) {
                      fields["vehicleName"] = value;
                    },
                    validator: (value) {
                      if (value == "") {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                    value: fields["vehicleType"],
                    items: vehicleTypes.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      fields["vehicleType"] = value as String;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text("Tipo de veículo"),
                    ),
                    validator: (value) {
                      if (value == "" || value == null) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Salvando')),
                      );
                      submit(context, noticeToEdit);
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(
                      double.maxFinite,
                      50,
                    )),
                  ),
                  child: const Text("Criar anúncio"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
