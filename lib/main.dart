import 'package:estore/constants.dart';
import 'package:estore/pages/customers/customers.dart';
import 'package:estore/pages/products/productdetails.dart';
import 'package:estore/pages/products/products.dart';
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
        useMaterial3: true,
        primaryColor: primaryColor,
        primaryColorDark: primaryColor,
        primaryColorLight: primaryColor,
        // colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green),
        brightness: Brightness.light,
        textTheme: TextTheme(
            displayLarge: TextStyle(color: secondryColor, fontSize: 23),
            displayMedium: TextStyle(color: secondryColor, fontSize: 20),
            displaySmall: TextStyle(color: secondryColor, fontSize: 18)),
      ),
      darkTheme: ThemeData(
        // useMaterial3: true,
        brightness: Brightness.dark,
        textTheme: TextTheme(
            displayLarge: TextStyle(color: Colors.white, fontSize: 23),
            displayMedium: TextStyle(color: Colors.white, fontSize: 20),
            displaySmall: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      themeMode: themeMode,
      // home: const Scaffold(
      //   body: BasePage(),
      // ),
      initialRoute: '/',
      routes: {
        '/': (context) => BasePage(),
        '/persons': (context) => CustomersScreen(),
        '/soon': (context) => Soon(),
      },
    );
  }

  void changeTheme(bool mode) async {
    setState(() {
      themeMode = mode != false ? ThemeMode.dark : ThemeMode.light;
    });
  }
}
