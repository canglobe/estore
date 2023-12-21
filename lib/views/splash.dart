import 'dart:async';
import 'package:estore/views/base_tabbar.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 1),
        () => Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (c) => const BaseTapBar()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Center(
            child: SizedBox(
                height: 150,
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(9),
                    ),
                    child: Image.asset('assets/start.png')))));
  }
}
