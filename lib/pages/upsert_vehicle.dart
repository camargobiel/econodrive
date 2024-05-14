import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/choose-vehicle-optionals.dart';
import 'package:econodrive/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpsertVehiclePage extends StatefulWidget {
  const UpsertVehiclePage({
    super.key,
  });

  @override
  State<UpsertVehiclePage> createState() => _UpsertVehiclePageState();
}

class _UpsertVehiclePageState extends State<UpsertVehiclePage> {
  final firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  String mainRoute = "/my-vehicles";

  Map<String, dynamic> fields = {
    'name': "",
    "type": "compactHatch",
    "avgConsumption": "",
    "optionals": [
      {"label": "Ar condicionado", "id": "air_conditioner", "value": false},
      {"label": "Central multimedia", "id": "multimedia", "value": false},
      {"label": "Radio Bluetooth", "id": "bluetooth_radio", "value": false},
      {"label": "Vidro elétrico", "id": "electric_window", "value": false},
      {"label": "Porta malas grande", "id": "big_trunk", "value": false},
    ]
  };

  _showOptionalsAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (buildContext) {
        return ChooseVehicleOptionalsAlert(
            onSave: (optionals) {
              setState(() {
                fields["optionals"] = optionals;
              });
              Navigator.pop(context);
            },
            options: fields["optionals"]);
      },
    );
  }

  _create(BuildContext context) async {
    var user = FirebaseAuth.instance.currentUser;
    var vehiclesCollectionRef =
        FirebaseFirestore.instance.collection("vehicles");
    var docRef = await vehiclesCollectionRef.add(
      {
        ...fields,
        "optionals":
            fields["optionals"].where((optional) => optional["value"] == true),
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
          'Veículo criado com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      mainRoute,
      (route) => false,
    );
  }

  _edit(BuildContext context, Map noticeToEdit) async {
    var vehiclesCollectionRef =
        FirebaseFirestore.instance.collection("vehicles");
    await vehiclesCollectionRef.doc(noticeToEdit["id"]).update(
      {
        ...fields,
      },
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Veículo salvo com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      mainRoute,
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
    Map? vehicleToEdit = arguments?["vehicle"];
    bool? edit = arguments?["edit"];

    vehicleToEdit?.forEach((key, value) {
      if (fields.containsKey(key)) {
        fields[key] = value;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: edit == true
            ? const Text("Editar veículo")
            : const Text("Criar veículo"),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          initialValue: fields["name"],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Nome do veículo"),
                          ),
                          onChanged: (value) {
                            fields["name"] = value;
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
                  Row(
                    children: [
                      Flexible(
                        child: DropdownButtonFormField(
                          value: fields["type"],
                          items: vehicleTypes.entries.map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            fields["type"] = value as String;
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          initialValue: fields["avgConsumption"],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text("Consumo médio (km/L)"),
                          ),
                          onChanged: (value) {
                            fields["avgConsumption"] = value;
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
                  ElevatedButton(
                    onPressed: () {
                      _showOptionalsAlert(context);
                    },
                    child: const Text("Escolher opcionais"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: fields["optionals"]
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
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  optional["label"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            )
                          ],
                        );
                      },
                    ).toList(),
                  )
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      _submit(context, vehicleToEdit);
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
                      : const Text("Criar veículo"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
