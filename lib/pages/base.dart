import 'package:estore/constants.dart';
import 'package:estore/main.dart';
import 'package:estore/pages/products/products.dart';
import 'package:flutter/material.dart';
import 'package:estore/pages/customers/customers.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int currentPageIndex = 0;

  List<Widget> pages = <Widget>[
    const ProductsPage(),
    const CustomersScreen(),
    const Soon()
  ];

  onDestinationSelected(index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.store,
              size: 27.5,
              // color: Colors.green,
            ),
            const SizedBox(
              width: 5,
            ),
            Text('Estore', style: mystyle(27.5, bold: true)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          onDestinationSelected(index);
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          //first navigation destination
          NavigationDestination(
            selectedIcon: Icon(Icons.inventory_2_sharp),
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),

          //second navigation destination
          NavigationDestination(
            selectedIcon: Icon(Icons.group_add_rounded),
            icon: Icon(Icons.group_add_outlined),
            label: 'Customers',
          ),

          //third navigation destination
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark),
            icon: Icon(Icons.settings_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[currentPageIndex],
    );
  }
}

class Soon extends StatefulWidget {
  const Soon({super.key});

  @override
  State<Soon> createState() => _SoonState();
}

class _SoonState extends State<Soon> {
  bool? darkmode;

  darkMode() {
    var mode = localdb.get('darkMode') ?? false;
    setState(() {
      darkmode = mode;
    });
  }

  @override
  void initState() {
    darkMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.dark_mode_outlined),
                const SizedBox(width: 5),
                const Text("DarkMode"),
                const SizedBox(width: 5),
                AnimatedSwitcher(
                  duration: const Duration(seconds: 3),
                  child: Switch(
                      value: darkmode!,
                      onChanged: (value) async {
                        MymaterialApp.of(context).changeTheme(value);
                        await localdb.put('darkMode', value);

                        setState(() {
                          darkmode = value;
                        });
                      }),
                ),
              ],
            ),
            const SizedBox(height: 15),
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
