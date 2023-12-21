// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/utils/theme_data.dart';

import 'base_tabbar.dart';
import 'calculator/calculator_screen.dart';
import 'customers/customers.dart';
import 'sold/sold.dart';
import 'splash.dart';

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

  void _getMode() async {
    bool isDark = await hiveDb.getThemeMode();
    changeTheme(isDark);
  }

  void changeTheme(isDark) async {
    await hiveDb.putThemeMode(isDark);
    setState(() {
      themeMode = isDark != false ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  void initState() {
    _getMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData.light(useMaterial3: false),
      // darkTheme: ThemeData.dark(useMaterial3: false),
      theme: lightThemeData(),
      darkTheme: darkThemeData(),
      themeMode: themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/base': (context) => const BaseTapBar(),
        '/customers': (context) => const CustomersScreen(),
        '/sold': (context) => const SoldScreen(),
        '/calculator': (context) => const Calculator(),
      },
    );
  }
}
