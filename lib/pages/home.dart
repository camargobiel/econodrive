import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/app-bar.dart';
import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:flutter/material.dart';
import '../components/notice_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  _readRecentNotices() {
    var notices = FirebaseFirestore.instance
        .collection("notices")
        .orderBy("createdAt", descending: true)
        .where("status", isEqualTo: "active")
        .limit(5)
        .snapshots();
    return notices;
  }

  _readNotices() {
    var notices = FirebaseFirestore.instance
        .collection("notices")
        .orderBy("withdrawDate", descending: false)
        .where("status", isEqualTo: "active")
        .snapshots();
    return notices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        screen: "/home",
      ),
      appBar: AppBar(
        title: const CustomAppBarTitle(),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(
                height: 600,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _readRecentNotices(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var notices = snapshot.data!.docs;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: notices.map(
                        (notice) {
                          return NoticeCard(
                            notice: notice,
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Todos os anúncios",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 600,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _readNotices(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    var notices = snapshot.data!.docs;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: notices.map(
                        (notice) {
                          return NoticeCard(
                            notice: notice,
                          );
                        },
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
