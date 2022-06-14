import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase/ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyBGVxXlz52guy1Rq0E5X3vIdMaz-efraPQ",
            authDomain: "fir-23c0b.firebaseapp.com",
            projectId: "fir-23c0b",
            storageBucket: "fir-23c0b.appspot.com",
            messagingSenderId: "882630676134",
            appId: "1:882630676134:web:7ac599bfa975bb6712ee67",
            measurementId: "G-6GRS27XM1S")
        : null,
  );
  runApp(const MyApp());
}
