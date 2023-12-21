// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:estore/api/fb.dart';
import 'package:estore/main.dart';
import 'package:flutter/material.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/views/sold/sold.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/products.dart';
import 'package:estore/views/customers/customers.dart';
import 'package:flutter/services.dart';

import 'ept1.dart';

class BaseTapBar extends StatefulWidget {
  const BaseTapBar({super.key});

  @override
  State<BaseTapBar> createState() => _BaseTapBarState();
}

class _BaseTapBarState extends State<BaseTapBar> with TickerProviderStateMixin {
  late final TabController _tabController;
  bool? isDarkMode;

  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        dataUpload();
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          closeIconColor: Colors.white,
          showCloseIcon: true,
          backgroundColor: Colors.red,
          content:
              Center(child: Text('I think your internet was not connected!')),
          duration: Duration(seconds: 9),
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future dataUpload() async {
    _showDialog('start');
    try {
      // get data from local database
      var pd = await hiveDb.getProductDetails();
      var ph = await hiveDb.getProductHistory();
      var pm = await hiveDb.getProductNames();
      var prh = await hiveDb.getPersonsHistory();
      var pr = await hiveDb.getPersonsNames();

      // upload to firebase realtime database
      await fb.ref().child('productDetails').set(pd);
      await fb.ref().child('productHistory()').set(ph);
      await fb.ref().child('productNames').set(pm);
      await fb.ref().child('customersHistory').set(prh);
      await fb.ref().child('customerNames').set(pr);
    } catch (e) {
      // print(e.toString());
    }

    popOut(context);
    _showDialog('completed');
    await Future.delayed(const Duration(seconds: 2));
    popOut(context);
  }

  popOut(context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1900),
        margin: EdgeInsets.only(bottom: 16, right: 32, left: 32),
        content: Text('Double Tap to exit'),
      ),
    );
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    DateTime backButtonPressedTime = DateTime.now();
    DateTime currentTime;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        currentTime = DateTime.now();
        int difference =
            currentTime.difference(backButtonPressedTime).inMilliseconds;
        backButtonPressedTime = currentTime;
        if (difference < 1000) {
          hideSnackBar();
          SystemNavigator.pop();
        } else {
          showSnackBar();
        }
      },
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: 90,
            leading: Image.asset(
              'assets/brand/brand_logo.png',
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const <Widget>[
                Tab(
                  icon: Icon(
                    Icons.group,
                    color: bgColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.category,
                    color: bgColor,
                  ),
                ),
                Tab(
                  icon: Icon(
                    Icons.sell,
                    color: bgColor,
                  ),
                ),
              ],
            ),
            actions: [
              //--- Cloud upload
              IconButton(
                onPressed: () async {
                  await localdb.clear();
                  setState(() {});

                  // var pn = await hiveDb.getProductNames();
                  // var pd = await hiveDb.getProductDetails();
                  // var ph = await hiveDb.getProductHistory();
                  // var pern = await hiveDb.getPersonsNames();
                  // var perh = await hiveDb.getPersonsHistory();
                  // var ovh = await hiveDb.getOverallHistory();

                  // print(pn);
                  // print(pd);
                  // print(ph);
                  // print(pern);
                  // print(perh);
                  // print(ovh);
                },
                icon: const Icon(
                  Icons.cloud_upload,
                  color: textDarkColor,
                ),
                tooltip: 'Cloud Upload',
              ),
              //--- Theme mode change
              IconButton(
                onPressed: () async {
                  var mode = await hiveDb.getThemeMode();
                  Ept1App.of(context).changeTheme(mode != true ? true : false);
                  setState(() => isDarkMode = !mode);
                },
                icon: Icon(
                  isDarkMode != true ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.amberAccent,
                ),
                tooltip: 'Theme Mode',
              ),
              //--- End of actions.
            ]),
        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            CustomersScreen(),
            ProductScreen(),
            SoldScreen(),
          ],
        ),
      ),
    );
  }

  _showDialog(status) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: status != 'completed'
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Uploading..'),
                      CircularProgressIndicator(),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Uploaded successful'),
                    ],
                  ),
          );
        });
  }
}
