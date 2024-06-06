import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:econodrive/components/app-bar.dart';
import 'package:econodrive/components/bottom-navigation-bar.dart';
import 'package:econodrive/components/select-city.dart';
import 'package:econodrive/utils/format-date.dart';
import 'package:flutter/material.dart';
import '../components/notice_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime? withdrawDate;
  DateTime? returnDate;
  String? originCity;
  String? destinyCity;

  Future<void> _selectWithdrawDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: withdrawDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != withdrawDate) {
      setState(() {
        withdrawDate = picked;
      });
    }
  }

  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: returnDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != returnDate) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  _chooseCity(String field) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SelectCity(
          onCitySelected: (city) {
            setState(() {
              if (field == "origin") {
                originCity = city;
              } else {
                destinyCity = city;
              }
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  _readRecentNotices() {
    var notices = FirebaseFirestore.instance
        .collection("notices")
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .limit(5)
        .snapshots();
    return notices;
  }

  _readNotices() {
    var notices = FirebaseFirestore.instance
        .collection("notices")
        .where("status", isEqualTo: "active")
        .orderBy("withdrawDate", descending: false);

    if (withdrawDate != null) {
      notices = notices.where(
        "withdrawDate",
        isEqualTo: formatDate(
          withdrawDate!.toIso8601String(),
        ),
      );
    }

    if (returnDate != null) {
      notices = notices.where(
        "returnDate",
        isEqualTo: formatDate(
          returnDate!.toIso8601String(),
        ),
      );
    }

    if (originCity != null) {
      notices = notices.where(
        "originCity",
        isEqualTo: originCity,
      );
    }

    if (destinyCity != null) {
      notices = notices.where(
        "destinyCity",
        isEqualTo: destinyCity,
      );
    }

    return notices.snapshots();
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
                    if (snapshot.data!.docs.isEmpty) {
                      return const Text("Nenhum anúncio recente encontrado");
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
              const Text(
                "Filtros:",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 35,
                width: double.infinity,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    withdrawDate != null
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                withdrawDate = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black45,
                            ),
                          )
                        : const SizedBox(),
                    ElevatedButton(
                      onPressed: () {
                        _selectWithdrawDate(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          withdrawDate == null ? Colors.white : Colors.red,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          withdrawDate == null ? Colors.red : Colors.white,
                        ),
                      ),
                      child: Text(
                        withdrawDate != null
                            ? "Data de retirada ${formatDate(withdrawDate!.toIso8601String())}"
                            : "Data de retirada",
                      ),
                    ),
                    returnDate != null
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                returnDate = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black45,
                            ),
                          )
                        : const SizedBox(
                            width: 10,
                          ),
                    ElevatedButton(
                      onPressed: () {
                        _selectReturnDate(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          returnDate == null ? Colors.white : Colors.red,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          returnDate == null ? Colors.red : Colors.white,
                        ),
                      ),
                      child: Text(
                        returnDate != null
                            ? "Data de devolução ${formatDate(returnDate!.toIso8601String())}"
                            : "Data de devolução",
                      ),
                    ),
                    originCity != null
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                originCity = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black45,
                            ),
                          )
                        : const SizedBox(
                            width: 10,
                          ),
                    ElevatedButton(
                      onPressed: () {
                        _chooseCity("origin");
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          originCity == null ? Colors.white : Colors.red,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          originCity == null ? Colors.red : Colors.white,
                        ),
                      ),
                      child: Text(
                        originCity != null ? "Origem $originCity" : "Origem",
                      ),
                    ),
                    destinyCity != null
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                destinyCity = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black45,
                            ),
                          )
                        : const SizedBox(
                            width: 10,
                          ),
                    ElevatedButton(
                      onPressed: () {
                        _chooseCity("destiny");
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent,
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          destinyCity == null ? Colors.white : Colors.red,
                        ),
                        foregroundColor: MaterialStateProperty.all<Color>(
                          destinyCity == null ? Colors.red : Colors.white,
                        ),
                      ),
                      child: Text(
                        destinyCity != null
                            ? "Destino $destinyCity"
                            : "Destino",
                      ),
                    ),
                  ],
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
                    if (snapshot.data!.docs.isEmpty) {
                      return const Text("Nenhum anúncio encontrado");
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
