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
        elevation: 0,
        title: Row(
          children: [
            // Icon(
            //   Icons.store,
            //   size: 33,
            //   color: redColor,
            // ),
            CircleAvatar(
              maxRadius: 14,
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(
              width: 5,
            ),
            Text('Estore', style: mystyle(33, bold: true, color: primaryColor)),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (int index) {
          onDestinationSelected(index);
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          //first navigation destination
          NavigationDestination(
            selectedIcon: Icon(
              Icons.inventory_2_sharp,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
              Icons.inventory_2_outlined,
              size: 23,
            ),
            label: 'Products',
          ),

          //second navigation destination
          NavigationDestination(
            selectedIcon: Icon(
              Icons.group_add_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: Icon(
              Icons.group_add_outlined,
              size: 23,
            ),
            label: 'Customers',
          ),

          //third navigation destination
          NavigationDestination(
            selectedIcon: Icon(
              Icons.bookmark,
              color: secondryColor,
              size: 27,
            ),
            icon: Icon(
              Icons.settings_outlined,
              size: 25,
            ),
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton(
                onPressed: () async {
                  await localdb.clear();
                },
                child: Text('Clear'))
          ],
        ),
      ),
    );
  }
}
