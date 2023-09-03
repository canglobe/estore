import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

//base page
import 'firebase_options.dart';
import 'pages/base.dart';

late Box localdb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  localdb = await Hive.openBox('db');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MymaterialApp(title: 'estore'));
}

class MymaterialApp extends StatefulWidget {
  const MymaterialApp({super.key, required this.title});

  final String title;

  @override
  State<MymaterialApp> createState() => _MymaterialAppState();
  static _MymaterialAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MymaterialAppState>()!;
}

class _MymaterialAppState extends State<MymaterialApp> {
  ThemeMode themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
          // useMaterial3: true,
          ),
      themeMode: themeMode,
      home: const Scaffold(
        body: BasePage(),
      ),
    );
  }

  void changeTheme(bool mode) async {
    setState(() {
      themeMode = mode != false ? ThemeMode.dark : ThemeMode.light;
    });
  }
}
