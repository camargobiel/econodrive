import 'package:flutter/material.dart';

class ChooseVehicleOptionalsAlert extends StatefulWidget {
  Function onSave;
  List<Map<String, dynamic>> options = [];

  ChooseVehicleOptionalsAlert({
    super.key,
    required this.onSave,
    required this.options,
  });

  @override
  State<ChooseVehicleOptionalsAlert> createState() =>
      _ChooseVehicleOptionalsAlertState();
}

class _ChooseVehicleOptionalsAlertState
    extends State<ChooseVehicleOptionalsAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Escolha os opcionais incluídos no veículo",
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.options.map<Widget>((optional) {
          return CheckboxListTile(
            value: optional["value"],
            onChanged: (value) {
              setState(() {
                widget.options = widget.options.map((option) {
                  if (option["id"] != optional["id"]) {
                    return option;
                  }
                  return {
                    ...option,
                    "value": !option["value"],
                  };
                }).toList();
              });
            },
            title: Text(optional["label"]),
          );
        }).toList(),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            widget.onSave(widget.options);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
