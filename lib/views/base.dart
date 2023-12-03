import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:estore/main.dart';
import 'package:estore/api/fb.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/products.dart';
import 'package:estore/views/customers/customers.dart';
import 'package:estore/views/calculator/calculator_screen.dart';

import 'package:firebase_database/firebase_database.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int currentPageIndex = 1;
  bool? isDark;

  final fb = FB();

  List<Widget> pages = <Widget>[
    const CustomersScreen(),
    const ProductScreen(),
    const Calculator(),
  ];

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
          content: Text('I think your internet was not connected!'),
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
      await fb.ref().child('personsHistory').set(prh);
      await fb.ref().child('personsNames').set(pr);
    } catch (e) {
      print(e.toString());
    }

    popOut(context);
    _showDialog('completed');
    await Future.delayed(const Duration(seconds: 2));
    popOut(context);
  }

  popOut(context) {
    Navigator.pop(context);
  }

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
          // ---------------------------------------------------------------------------- Cloud Upload
          IconButton(
            onPressed: () async {
              checkUserConnection();
              setState(() {});
            },
            icon: const Icon(Icons.cloud_upload_outlined),
            tooltip: 'Cloud Upload',
          ),
          // ---------------------------------------------------------------------------- Mode Change
          IconButton(
            onPressed: () async {
              var mode = localdb.get('darkMode');

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
        destinations: <Widget>[
          // ---------------------------------------------------------------------------- Customers
          NavigationDestination(
            selectedIcon: Icon(
              Icons.group,
              color: secondryColor,
              size: 23,
            ),
            icon: const Icon(
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
            icon: const Icon(
              Icons.category_outlined,
              size: 23,
            ),
            label: 'Products',
          ),

          // ---------------------------------------------------------------------------- Calculator
          NavigationDestination(
            selectedIcon: Icon(
              Icons.calculate_rounded,
              color: secondryColor,
              size: 23,
            ),
            icon: const Icon(
              Icons.calculate_outlined,
              size: 23,
            ),
            label: 'Calculator',
          ),
          // ---------------------------------------------------------------------------- End of NavigationBar
        ],
      ),
      body: pages[currentPageIndex],
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

// future need for chat feature
class Soon extends StatefulWidget {
  const Soon({super.key});

  @override
  State<Soon> createState() => _SoonState();
}

final chatController = TextEditingController();
bool isTyping = false;

class _SoonState extends State<Soon> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: StreamBuilder(
              stream: FirebaseDatabase.instance.ref().child('chat').onValue,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  DataSnapshot dataSnapshot = snapshot.data!.snapshot;
                  Object? usersData = dataSnapshot.value;

                  List keys = [];
                  List values = [];
                  var map = usersData as Map;
                  map.forEach(
                    (key, value) {
                      keys.add(key);
                      values.add(value as Map);
                    },
                  );

                  keys.sort();
                  keys = keys.reversed.toList();
                  return ListView.builder(
                      reverse: true,
                      itemCount: keys.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          trailing: Text(
                            map[keys[index]]
                                .toString()
                                .replaceRange(0, 10, '')
                                .replaceAll(RegExp('}'), ''),
                            maxLines: 5,
                            softWrap: true,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  // height: ,
                  child: TextField(
                    controller: chatController,
                    decoration: InputDecoration(
                      prefix: Icon(
                        Icons.messenger_outline,
                        color: secondryColor,
                        // size: 30,
                      ),
                      suffix: isTyping != false
                          ? FloatingActionButton.small(
                              backgroundColor: secondryColor,
                              child: const Icon(Icons.send),
                              onPressed: () async {
                                var date =
                                    DateTime.now().toString().substring(0, 19);

                                Map chat = await localdb.get('chat') ?? {};
                                chat[date.toString()] = {
                                  'message': chatController.text,
                                };

                                await localdb.put('chat', chat);

                                FirebaseDatabase.instance.ref('chat').set(chat);
                                chatController.text = '';
                              },
                            )
                          : const Text(''),
                      border: const OutlineInputBorder(),
                      labelText: 'Type Message here',
                    ),
                    onChanged: (value) => setState(() {
                      isTyping = true;
                    }),
                    onTapOutside: (event) => setState(() {
                      isTyping = false;
                    }),
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }
}
