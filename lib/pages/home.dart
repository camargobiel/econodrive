import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  _logout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  _readUser() {
    var user = FirebaseAuth.instance.currentUser;
    var account = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    return account.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<dynamic>(
          stream: _readUser(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            bool isRentalCompany = snapshot.data["type"] == "rental";
            if (isRentalCompany == false) {
              return const SizedBox();
            }
            return FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "/new-notice");
              },
              child: const Icon(Icons.add),
            );
          }),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "../../images/logo.png",
              width: 140,
            ),
            TextButton(
              onPressed: () {
                _logout(context);
              },
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Anúncios recentes",
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
              child: Center(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 420,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(10, (int index) {
                          return Card(
                            child: SizedBox(
                              width: 400,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                ),
                                child: Column(
                                  children: [
                                    const Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "São José do Rio Preto",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 17,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "Manaus",
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        "https://imgd-ct.aeplcdn.com/664x415/n/cw/ec/141125/kwid-exterior-right-front-three-quarter-3.jpeg?isig=0&q=80",
                                        width: 200,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      "Renault Kwid 2024",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Text(
                                      "Hatch compacto 1.0",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const Text(
                                      "Ar condicionado, vidros elétricos...",
                                      style: TextStyle(
                                        color: Colors.black45,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(
                                          double.maxFinite,
                                          50,
                                        )),
                                      ),
                                      child: const Text("RESERVAR AGORA"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
