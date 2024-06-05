import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:econodrive/components/my_reservation_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyReservations extends StatefulWidget {
  const MyReservations({super.key});

  @override
  State<MyReservations> createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  _readReservations() {
    var user = FirebaseAuth.instance.currentUser;
    var reservations = FirebaseFirestore.instance
        .collection("notices")
        .where("rentedById", isEqualTo: user!.uid)
        .snapshots();
    return reservations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        screen: "/my-reservations",
      ),
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Minhas reservas",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder<dynamic>(
                  stream: _readReservations(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data?.docs.isEmpty) {
                      return const Text("Você não possui reservas.");
                    }
                    return Column(
                      children: snapshot.data!.docs.map<Widget>(
                        (reservation) {
                          return MyReservationCard(
                            reservation: reservation,
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
