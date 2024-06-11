import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/select-city.dart';
import 'package:econodrive/components/select_vehicle_alert.dart';
import 'package:econodrive/utils/format-date.dart';
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
  Map? selectedVehicle;
  bool _isInitialized = false;
  Map? _noticeToEdit;
  bool? _isEditing = false;
  DateTime withdrawDate = DateTime.now();
  DateTime returnDate = DateTime.now();

  Map<String, dynamic> fields = {
    'originCity': "",
    "destinyCity": "",
    "withdrawDate": "",
    "returnDate": "",
    "observation": "",
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
    try {
      var user = FirebaseAuth.instance.currentUser;
      var noticesCollectionRef =
          FirebaseFirestore.instance.collection("notices");
      var docRef = await noticesCollectionRef.add(
        {
          ...fields,
          "createdBy": user!.uid,
          "createdByName": user.displayName,
          "createdAt": DateTime.now().toIso8601String(),
          "vehicleId": selectedVehicle!["id"],
          "status": "active",
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
    } catch (e) {}
  }

  _edit(BuildContext context, Map noticeToEdit) async {
    var noticesCollectionRef = FirebaseFirestore.instance.collection("notices");
    await noticesCollectionRef.doc(noticeToEdit["id"]).update(
      {
        ...fields,
        "vehicleId": selectedVehicle!["id"],
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

  _selectVehicle(BuildContext context) {
    showModalBottomSheet(
      builder: (modalContext) {
        return SelectVehicle(
          onSave: (vehicle) {
            setState(() {
              selectedVehicle = vehicle;
            });
            Navigator.pop(context);
          },
          selectedVehicleId: selectedVehicle?["id"],
        );
      },
      context: context,
    );
  }

  Future<void> _selectWithdrawDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: withdrawDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != withdrawDate) {
      setState(() {
        withdrawDate = picked;
        fields["withdrawDate"] = formatDate(picked.toIso8601String());
      });
    }
  }

  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: returnDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != returnDate) {
      setState(() {
        returnDate = picked;
        fields["returnDate"] = formatDate(picked.toIso8601String());
      });
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? _readNoticeVehicle() {
    if (_noticeToEdit == null) return null;
    var user = FirebaseAuth.instance.currentUser;
    var vehicles = FirebaseFirestore.instance
        .collection("vehicles")
        .where("createdBy", isEqualTo: user!.uid)
        .where("id", isEqualTo: _noticeToEdit!["vehicleId"])
        .snapshots();
    return vehicles;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final arguments = (ModalRoute.of(context)?.settings.arguments) as Map?;
      Map? noticeToEdit = arguments?["notice"];
      bool? edit = arguments?["edit"];

      setState(() {
        _noticeToEdit = noticeToEdit;
        _isEditing = edit;
      });

      if (noticeToEdit != null) {
        setState(() {
          withdrawDate = stringDateToDatetime(noticeToEdit["withdrawDate"])!;
          returnDate = stringDateToDatetime(noticeToEdit["returnDate"])!;
        });
      }

      noticeToEdit?.forEach((key, value) {
        if (fields.containsKey(key)) {
          fields[key] = value;
        }
      });
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEditing == true
            ? const Text("Editar anúncio")
            : const Text("Criar anúncio"),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _submit(context, _noticeToEdit);
              }
            },
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(
                double.maxFinite,
                50,
              )),
            ),
            child: _isEditing == true
                ? const Text("Salvar")
                : const Text("Criar anúncio"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
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
                                    ? "Origem"
                                    : "Origem: ${fields["originCity"]}",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.arrow_circle_right,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
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
                                    ? "Destino"
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Data de retirada"),
                            ),
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obrigatório";
                              }
                              return null;
                            },
                            onTap: () {
                              _selectWithdrawDate(context);
                            },
                            controller: TextEditingController(
                              text: fields["withdrawDate"] != ""
                                  ? fields["withdrawDate"]
                                  : "",
                            ),
                          ),
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
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obrigatório";
                              }
                              return null;
                            },
                            onTap: () {
                              _selectReturnDate(context);
                            },
                            controller: TextEditingController(
                              text: fields["returnDate"] != ""
                                  ? fields["returnDate"]
                                  : "",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<dynamic>(
                      stream: _readNoticeVehicle(),
                      builder: (context, snapshot) {
                        if (_isEditing == true &&
                            snapshot.hasData &&
                            selectedVehicle == null) {
                          List<dynamic> vehicles = snapshot.data.docs
                              .map((e) => e.data() as Map<String, dynamic>)
                              .toList();
                          Map vehicle = vehicles[0];
                          selectedVehicle = vehicle;
                        }
                        if (selectedVehicle == null) {
                          return OutlinedButton(
                            onPressed: () {
                              _selectVehicle(context);
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                const Size(double.maxFinite, 50),
                              ),
                            ),
                            child: const Text("Selecionar veículo"),
                          );
                        }
                        return OutlinedButton(
                          onPressed: () {
                            _selectVehicle(context);
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                              const Size(double.maxFinite, 50),
                            ),
                          ),
                          child: Text(
                            "Selecionado: ${selectedVehicle!["name"]}",
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Observações",
                      ),
                      initialValue: fields["observation"],
                      onChanged: (value) {
                        fields["observation"] = value;
                      },
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
