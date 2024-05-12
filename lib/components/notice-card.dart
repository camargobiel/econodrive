import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NoticeCard extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> notice;

  const NoticeCard({
    super.key,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notice["originCity"],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 17,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    notice["destinyCity"],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    notice["withdrawDate"],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    size: 17,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    notice["returnDate"],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
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
              Text(
                notice["vehicleName"],
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                vehicleTypes[notice["vehicleType"]]!,
                style: const TextStyle(
                  fontSize: 16,
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
                    ),
                  ),
                ),
                child: const Text("RESERVAR AGORA"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
