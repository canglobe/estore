import 'package:estore/views/calculator/calculator_screen.dart';
import 'package:estore/views/customers/customers.dart';
import 'package:estore/views/splash.dart';
import 'package:estore/utils/appdata.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'views/base.dart';

late Box localdb;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // intiate hive local database
  await Hive.initFlutter();
  localdb = await Hive.openBox('db');

  // intiate firebase in this app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // run this app
  runApp(const Ept1App(title: 'Ept1'));
}

class Ept1App extends StatefulWidget {
  const Ept1App({super.key, required this.title});

  final String title;

  @override
  State<Ept1App> createState() => _Ept1AppState();
  static _Ept1AppState of(BuildContext context) =>
      context.findAncestorStateOfType<_Ept1AppState>()!;
}

class _Ept1AppState extends State<Ept1App> {
  ThemeMode? themeMode;

  getMode() async {
    var isDark = await localdb.get('darkMode') ?? false;
    changeTheme(isDark);
  }

  void changeTheme(isDark) async {
    await localdb.put('darkMode', isDark);
    setState(() {
      themeMode = isDark != false ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  void initState() {
    getMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(),
      darkTheme: darkThemeData(),
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/base': (context) => const BaseScreen(),
        '/customers': (context) => const CustomersScreen(),
        '/calculator': (context) => const Calculator(),
      },
    );
  }
}
