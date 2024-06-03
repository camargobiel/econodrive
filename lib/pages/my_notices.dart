import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/app-bar.dart';
import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_notice_card.dart';

class MyNotices extends StatefulWidget {
  const MyNotices({super.key});

  @override
  State<MyNotices> createState() => _MyNoticesState();
}

class _MyNoticesState extends State<MyNotices> {
  _readNotices() {
    var user = FirebaseAuth.instance.currentUser;
    var notices = FirebaseFirestore.instance
        .collection("notices")
        .where("createdBy", isEqualTo: user!.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
    return notices;
  }

  _readUser() {
    var user = FirebaseAuth.instance.currentUser;
    var account = FirebaseFirestore.instance.collection("users").doc(user!.uid);
    return account.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        screen: "/my-notices",
      ),
      appBar: AppBar(
        title: const CustomAppBarTitle(),
      ),
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
              Navigator.pushNamed(context, "/upsert-notice");
            },
            child: const Icon(Icons.add),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Meus anúncios",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _readNotices(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  var notices = snapshot.data!.docs;
                  return Column(
                    children: notices.map(
                      (notice) {
                        return MyNoticeCard(
                          notice: notice,
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
    );
  }
}
