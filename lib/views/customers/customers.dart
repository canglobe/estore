import 'package:flutter/material.dart';

import 'package:estore/main.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/customers/customer_details.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final nameController = TextEditingController();
  final searchController = TextEditingController();

  bool ifintialloading = true;
  bool searchEnable = false;

  getData(value) async {
    List personNames = await localdb.get('personsNames') ?? [];

    if (value == '') {
      return personNames;
    } else {
      personNames = personNames
          .where(
              (element) => element.toLowerCase().contains(value.toLowerCase()))
          .toList();

      return personNames;
    }
  }

  addNewCustomer() async {
    List personNames = await localdb.get('personsNames') ?? [];
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    bool ifExist = !personNames.contains(nameController.text);

    if (nameController.text.isNotEmpty && ifExist) {
      personNames.add(nameController.text);
      // Map data = {nameController.text: {}};

      await localdb.put('personsNames', personNames);
      await localdb.put('personsHistory', personsHistory);
      nameController.text = '';
      _popOut();

      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _subTitle(),
          _searchBox(),
          const Divider(),
          _bodyContent(),
        ],
      ),
      floatingActionButton: _fab(),
    );
  }

  _subTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Customers',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            IconButton(
                onPressed: () {
                  if (searchEnable != false) {
                    setState(() {
                      searchEnable = false;
                    });
                  } else {
                    setState(() {
                      searchEnable = true;
                    });
                  }
                },
                icon: const Icon(Icons.search_outlined))
          ],
        ),
      ),
    );
  }

  _searchBox() {
    return Visibility(
      visible: searchEnable,
      child: Padding(
        padding: const EdgeInsets.all(4.5),
        child: TextField(
          controller: searchController,
          onChanged: (value) {
            getData(value);
            setState(() {});
          },
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
              prefixIcon: Container(
                padding: const EdgeInsets.all(15),
                width: 18,
                child: const Icon(Icons.search_outlined),
              )),
        ),
      ),
    );
  }

  _bodyContent() {
    return Expanded(
        child: FutureBuilder(
      future: getData(searchController.text.trim()),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          List snap = snapshot.data;
          snap.sort();

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(9))),
                      child: GestureDetector(
                        onTap: () {
                          var person = snap[index];
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CustomerDetailsScreen(
                                    person: person,
                                    ifsell: false,
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Text(
                                  snap[index]
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ),
                              title: Text(
                                snap[index].toString().toUpperCase(),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerDetailsScreen(
                                                  person: snap[index],
                                                  ifsell: true,
                                                )));
                                  },
                                  icon: const Icon(Icons.chevron_right))),
                        ),
                      ),
                    );
                  },
                  itemCount: snap.length,
                ),
              ),
            ],
          );
        } else {
          return const Center();
        }
      },
    ));
  }

  _fab() {
    return FloatingActionButton.extended(
      onPressed: () {
        _showDialog();
      },
      label: const Icon(Icons.add),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            content: const Text('New Customer'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: addNewCustomer,
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  _popOut() {
    Navigator.pop(context);
  }
}
