import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SelectVehicle extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  final String? selectedVehicleId;

  const SelectVehicle({
    super.key,
    required this.onSave,
    this.selectedVehicleId,
  });

  @override
  State<SelectVehicle> createState() => _SelectVehicleState();
}

class _SelectVehicleState extends State<SelectVehicle> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  _readVehicles() {
    var user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection("vehicles")
        .where("createdBy", isEqualTo: user!.uid)
        .snapshots();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: StreamBuilder<QuerySnapshot>(
        stream: _readVehicles(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var vehicles = snapshot.data!.docs;
          if (_searchText.isNotEmpty) {
            vehicles = vehicles.where((vehicle) {
              var name = vehicle["name"].toString().toLowerCase();
              return name.contains(_searchText.toLowerCase());
            }).toList();
          }

          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquise por um veículo',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView(
                  children: vehicles.map<Widget>((vehicle) {
                    bool isSelected = widget.selectedVehicleId == vehicle.id;
                    return ListTile(
                      title: Text(vehicle["name"]),
                      subtitle: Text(vehicleTypes[vehicle["type"]]!),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          vehicle["image"],
                        ),
                      ),
                      tileColor:
                          isSelected ? Colors.red.withOpacity(0.1) : null,
                      onTap: () {
                        widget.onSave(vehicle.data() as Map<String, dynamic>);
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
