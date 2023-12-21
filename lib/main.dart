import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';

import 'views/ept1.dart';
import 'firebase_options.dart';

late Box localdb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // intiate hive database
  localdb = await Hive.openBox('db');

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // intiate firebase in this app
  );

  runApp(const Ept1App(title: 'Ept1'));
}
