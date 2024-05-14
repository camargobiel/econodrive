import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/utils/constants.dart';
import 'package:flutter/material.dart';

class MyVehicleCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> vehicle;

  const MyVehicleCard({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      "https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/141125/kwid-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80",
                      height: 180,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vehicle["name"],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  vehicleTypes[vehicle["type"]]!,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Consumo médio: ${vehicle['avgConsumption']}km/L",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Opcionais:",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: vehicle["optionals"]
                      .where((item) => item["value"] == true)
                      .map<Widget>(
                    (optional) {
                      return Text(
                        optional["label"],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      );
                    },
                  ).toList(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
