import 'package:estore/constants.dart';
import 'package:estore/pages/products/products.dart';
import 'package:flutter/material.dart';
import 'package:estore/pages/customers/customers.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estore',
          style: mystyle(27.5, bold: true),
        ),
        actions: const [
          // IconButton(
          //   icon: const Icon(Icons.dark_mode),
          //   onPressed: () async {
          //     await localdb.clear();
          //     //
          //   },
          // ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.inventory_2_sharp),
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.group_add_rounded),
            icon: Icon(Icons.group_add_outlined),
            label: 'Customers',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.settings_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        const ProductsScreen(),
        const CustomersScreen(),
        const Soon()
      ][currentPageIndex],
    );
  }
}

class Soon extends StatefulWidget {
  const Soon({super.key});

  @override
  State<Soon> createState() => _SoonState();
}

class _SoonState extends State<Soon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Coming Soon..'),
            Text(
              DateTime.now().toString().substring(0, 16),
              style: mystyle(24, bold: false),
            ),
          ],
        ),
      ),
    );
  }
}
