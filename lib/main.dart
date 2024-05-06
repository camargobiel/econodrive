import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyC8nBho0jKTLxr1sBBkNHigr9YAvsp0k-A",
    authDomain: "econodrive-6aa22.firebaseapp.com",
    projectId: "econodrive-6aa22",
    storageBucket: "econodrive-6aa22.appspot.com",
    messagingSenderId: "558904259213",
    appId: "1:558904259213:web:7b9c59c86884b32e1ca8c4",
  );
  await Firebase.initializeApp(options: firebaseConfig);

  runApp(const EconoDrive());
}
