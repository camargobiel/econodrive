import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/select-city.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpsertNoticePage extends StatefulWidget {
  const UpsertNoticePage({
    super.key,
  });

  @override
  State<UpsertNoticePage> createState() => _UpsertNoticePageState();
}

class _UpsertNoticePageState extends State<UpsertNoticePage> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> fields = {
    'originCity': "",
    "destinyCity": "",
    "withdrawDate": "",
    "returnDate": "",
    "vehicleName": "",
    "vehicleType": "compactHatch"
  };

  _chooseCity(String field) {
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
        "createdByName": user.displayName,
        "createdAt": DateTime.now().toIso8601String(),
      },
    );
    var noticeId = docRef.id;
    await docRef.update({
      "id": noticeId,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Anúncio criado com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/my-notices",
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Anúncio salvo com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      "/my-notices",
      (route) => false,
    );
  }

  _submit(BuildContext context, Map? noticeToEdit) async {
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
    bool? edit = arguments?["edit"];

    if (fields["originCity"] == "") {
      noticeToEdit?.forEach((key, value) {
        if (fields.containsKey(key)) {
          fields[key] = value;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: edit == true
            ? const Text("Editar anúncio")
            : const Text("Criar anúncio"),
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
                              _chooseCity("originCity");
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
                              _chooseCity("destinyCity");
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
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _submit(context, noticeToEdit);
                    }
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(
                      double.maxFinite,
                      50,
                    )),
                  ),
                  child: edit == true
                      ? const Text("Salvar")
                      : const Text("Criar anúncio"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
