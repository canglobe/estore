// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:estore/hive/hivebox.dart';

import 'package:estore/views/sold/sold.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/products.dart';
import 'package:estore/views/customers/customers.dart';

import 'ept1.dart';

// The start code of Bottom Navigation Bar
class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 1;
  bool? isDark;

  List<Widget> pages = <Widget>[
    const CustomersScreen(),
    const ProductScreen(),
    const SoldScreen(),
  ];

  onDestinationSelected(index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        elevation: 0,
        leading: Image.asset(
          'assets/brand/brand_logo.png',
        ),
        actions: [
          // ---------------------------------------------------------------------------- Calculator
          IconButton(
            onPressed: () async {
              // await localdb.clear();
            },
            icon: const Icon(Icons.calculate_outlined),
            tooltip: 'Cloud Upload',
          ),
          // ---------------------------------------------------------------------------- Mode Change
          IconButton(
            onPressed: () async {
              var mode = await hiveDb.getThemeMode();

              Ept1App.of(context)
                  .changeTheme(mode = mode == true ? false : true);
              setState(() {
                isDark = !mode;
              });
            },
            icon: Icon(isDark != true
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            tooltip: 'Mode',
          ),
          // ---------------------------------------------------------------------------- End of Actions
        ],
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          onDestinationSelected(index);
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          // ---------------------------------------------------------------------------- Customers
          NavigationDestination(
            selectedIcon: Icon(
              Icons.group,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
              Icons.group_outlined,
              size: 23,
            ),
            label: 'Customers',
          ),

          // ---------------------------------------------------------------------------- products
          NavigationDestination(
            selectedIcon: Icon(
              Icons.category_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
              Icons.category_outlined,
              size: 23,
            ),
            label: 'Products',
          ),

          // ---------------------------------------------------------------------------- Calculator
          NavigationDestination(
            selectedIcon: Icon(
              Icons.sell_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
              Icons.sell_outlined,
              size: 23,
            ),
            label: 'Solded',
          ),
          // ---------------------------------------------------------------------------- End of NavigationBar
        ],
      ),
      body: pages[currentPageIndex],
    );
  }

  show(status) {
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

//  The End code of Bottom Navigation Bar
