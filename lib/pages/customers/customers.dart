import 'dart:math';

import 'package:estore/constants.dart';
import 'package:estore/main.dart';

import 'package:flutter/material.dart';
import 'package:estore/pages/customers/customerdetails.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  getData() async {
    Map ldbcc = await localdb.get('ldbcc') ?? {};

    return ldbcc;
  }

  List colorslist = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              'My Customers',
              style: mystyle(
                22,
              ),
            ),
          ),
        ),
        const Divider(),
        Expanded(
            child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              List keys = [];
              Map snap = snapshot.data;

              for (var x in snap.keys) {
                keys.add(x);
              }

              keys.sort();

              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          var pname = keys[index];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CustomerDetailsScreen(
                                    pname: pname,
                                  )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: colorslist[Random().nextInt(7)],
                            child: Text(
                                keys[index]
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          title: Text(
                            keys[index],
                            style: mystyle(20, bold: true),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ),
                    );
                  },
                  itemCount: keys.length,
                ),
              );
            } else {
              return progress();
            }
          },
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showbox();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  final nameController = TextEditingController();

  bool ifintialloading = true;
  Widget progress() {
    loading();
    return ifintialloading == true
        ? const SizedBox()
        : const Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.info),
              SizedBox(
                width: 3,
              ),
              Text('First add any one product and \nthen add Customers'),
            ],
          ));
  }

  loading() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      ifintialloading = false;
    });
  }

  showbox() {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: const Text('New Customer'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Customer Name',
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  //
                  Map ldbcc =
                      await localdb.get('ldbcc') ?? {nameController.text: {}};
                  ldbcc[nameController.text] = {};
                  await localdb.put('ldbcc', ldbcc);
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text('Done'),
              ),
            ],
          );
        });
  }
}
