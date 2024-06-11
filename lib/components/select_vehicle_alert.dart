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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _searchText = '';

  Future<Map<String, String>> _getExcludedVehicleIdsWithReasons() async {
    var querySnapshot = await _firestore
        .collection("notices")
        .where("createdBy", isEqualTo: _auth.currentUser!.uid)
        .where("status", whereIn: ['active', 'reserved']).get();

    Map<String, String> vehicleIdsWithReasons = {};
    for (var doc in querySnapshot.docs) {
      vehicleIdsWithReasons[doc['vehicleId']] = doc['status'];
    }

    return vehicleIdsWithReasons;
  }

  Stream<QuerySnapshot> _readVehicles(
      Map<String, String> excludedVehicleIdsWithReasons) {
    var user = _auth.currentUser;
    var excludedVehicleIds = excludedVehicleIdsWithReasons.keys.toList();
    if (excludedVehicleIds.isEmpty) {
      return _firestore
          .collection("vehicles")
          .where("createdBy", isEqualTo: user!.uid)
          .snapshots();
    } else {
      return _firestore
          .collection("vehicles")
          .where("createdBy", isEqualTo: user!.uid)
          .snapshots();
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchText != _searchController.text) {
        setState(() {
          _searchText = _searchController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
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
            child: FutureBuilder<Map<String, String>>(
              future: _getExcludedVehicleIdsWithReasons(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                Map<String, String> excludedVehicleIdsWithReasons =
                    snapshot.data ?? {};

                return StreamBuilder<QuerySnapshot>(
                  stream: _readVehicles(excludedVehicleIdsWithReasons),
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

                    return ListView(
                      children: vehicles.map<Widget>((vehicle) {
                        bool isSelected =
                            widget.selectedVehicleId == vehicle.id;
                        bool isExcluded = excludedVehicleIdsWithReasons
                            .containsKey(vehicle.id);
                        String statusMessage = '';
                        if (isExcluded) {
                          statusMessage =
                              excludedVehicleIdsWithReasons[vehicle.id] ==
                                      'active'
                                  ? 'Este veículo está em um anúncio ativo.'
                                  : 'Este veículo está reservado.';
                        }
                        return ListTile(
                          title: Text(vehicle["name"],
                              style: TextStyle(
                                color: isExcluded ? Colors.black45 : null,
                              )),
                          subtitle: Text(
                            vehicleTypes[vehicle["type"]]! +
                                (isExcluded ? ' - $statusMessage' : ''),
                            style: TextStyle(
                              color: isExcluded ? Colors.black38 : null,
                            ),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              vehicle["image"],
                              color: isExcluded ? Colors.black : null,
                              colorBlendMode: BlendMode.saturation,
                            ),
                          ),
                          tileColor:
                              isSelected ? Colors.red.withOpacity(0.1) : null,
                          trailing: isExcluded
                              ? const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                )
                              : null,
                          onTap: isExcluded
                              ? null
                              : () {
                                  widget.onSave(
                                      vehicle.data() as Map<String, dynamic>);
                                },
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
