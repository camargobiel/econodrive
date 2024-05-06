import 'package:econodrive/components/select-city.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NewNoticePage extends StatefulWidget {
  const NewNoticePage({super.key});

  @override
  State<NewNoticePage> createState() => _NewNoticePageState();
}

class _NewNoticePageState extends State<NewNoticePage> {
  Map<String, dynamic> fields = {
    'originCity': "",
    "destinyCity": "",
    "withdrawDate": "",
    "returnDate": "",
    "vehicleName": "",
    "vehicleType": ""
  };

  chooseCity() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return const SelectCity();
      },
    );
  }

  submit() {
    print(fields);
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                      ElevatedButton(
                        onPressed: () {
                          chooseCity();
                        },
                        style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(
                            Size.fromHeight(40),
                          ),
                        ),
                        child: const Text("Selecionar cidade de origem"),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black54,
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                          fixedSize: MaterialStatePropertyAll(
                            Size.fromHeight(40),
                          ),
                        ),
                        onPressed: () {
                          chooseCity();
                        },
                        child: const Text("Selecionar cidade de destino"),
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
                    items: vehicleTypes,
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
                        const SnackBar(content: Text('Processing Data')),
                      );
                      submit();
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
