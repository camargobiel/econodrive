import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/app-bar.dart';
import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:econodrive/components/my_vehicle_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyVehicles extends StatelessWidget {
  const MyVehicles({super.key});

  _readVehicles() {
    var user = FirebaseAuth.instance.currentUser;
    var vehicles = FirebaseFirestore.instance
        .collection("vehicles")
        .where("createdBy", isEqualTo: user!.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
    return vehicles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        screen: "/my-vehicles",
      ),
      appBar: AppBar(
        title: const CustomAppBarTitle(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/upsert-vehicle");
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Meus veículos",
            style: TextStyle(
              color: Colors.red,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _readVehicles(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(child: const CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Text("Nenhum veículo encontrado");
                }

                var vehicles = snapshot.data!.docs;
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: vehicles.map(
                    (vehicle) {
                      return MyVehicleCard(
                        vehicle: vehicle,
                      );
                    },
                  ).toList(),
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
