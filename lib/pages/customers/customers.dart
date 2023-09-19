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
  final nameController = TextEditingController();

  bool ifintialloading = true;
  Widget progress() {
    // loading();
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
    await Future.delayed(const Duration(milliseconds: 100));
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
                onPressed: newCustomer,
                child: const Text('Done'),
              ),
            ],
          );
        });
  }

  void newCustomer() async {
    //
    List personNames = await localdb.get('personsNames') ?? [];
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    bool ifExist = !personNames.contains(nameController.text);
    if (nameController.text.isNotEmpty && ifExist) {
      personNames.add(nameController.text);
      Map data = {nameController.text: {}};

      await localdb.put('personsNames', personNames);
      await localdb.put('personsHistory', personsHistory);
      nameController.text = '';
      nameController.text = '';
      navigation();

      setState(() {});
    } else {}
  }

  navigation() {
    Navigator.pop(context);
  }

  getData() async {
    List personNames = await localdb.get('personsNames') ?? [];

    return personNames;
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
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'My Customers',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ),
        const Divider(),
        Expanded(
            child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              List snap = snapshot.data;
              snap.sort();

              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          var person = snap[index];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CustomerDetailsScreen(
                                    person: person,
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorslist[Random().nextInt(7)],
                              child: Text(
                                snap[index]
                                    .toString()
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                            title: Text(
                              snap[index].toString().toUpperCase(),
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            trailing: const Icon(Icons.chevron_right),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: snap.length,
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
}
