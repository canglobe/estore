import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:estore/hive/hivebox.dart';
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

  bool showFab = true;
  bool searchEnable = false;

  getData(value) async {
    List personNames = await hiveDb.getPersonsNames();

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
    List personNames = await hiveDb.getPersonsNames();
    Map personsHistory = await hiveDb.getPersonsHistory();
    bool ifExist = !personNames.contains(nameController.text);

    if (nameController.text.isNotEmpty && ifExist) {
      personNames.add(nameController.text);

      await hiveDb.putPersonsNames(personNames);
      await hiveDb.putPersonsHistory(personsHistory);
      nameController.text = '';
      navToPop();

      setState(() {});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          final ScrollDirection direction = notification.direction;
          setState(() {
            if (direction == ScrollDirection.reverse) {
              showFab = false;
            } else if (direction == ScrollDirection.forward) {
              showFab = true;
            }
          });
          return true;
        },
        child: Column(
          children: [
            _subTitle(),
            _searchBox(),
            const Divider(),
            _bodyContent(),
          ],
        ),
      ),
      floatingActionButton: _fab(),
    );
  }

  _subTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Customers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
                onPressed: () {
                  if (searchEnable != false) {
                    setState(() => searchEnable = false);
                  } else {
                    setState(() => searchEnable = true);
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
        padding: const EdgeInsets.only(left: 9, right: 9),
        child: SizedBox(
          height: 59,
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
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                prefixIcon: Container(
                  padding: const EdgeInsets.only(left: 9),
                  width: 14,
                  child: const Icon(Icons.search_outlined),
                )),
          ),
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

          return Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0.3,
                  color: const Color.fromRGBO(250, 253, 254, 1),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(9))),
                  child: GestureDetector(
                    onTap: () {
                      navToCustomerDetails(
                          customerName: snap[index], ifsell: false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ListTile(
                          // Customer intial letter
                          leading: CircleAvatar(
                            backgroundColor: primaryColor,
                            child: Text(
                              snap[index]
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .apply(color: Colors.white),
                            ),
                          ),
                          // Customer name
                          title: Text(
                            snap[index].toString().toUpperCase(),
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          // Navigate to sell
                          trailing: IconButton(
                              onPressed: () {
                                navToCustomerDetails(
                                    customerName: snap[index], ifsell: true);
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                color: textLightColor,
                              ))),
                    ),
                  ),
                );
              },
              itemCount: snap.length,
            ),
          );
        } else {
          return const Center(
            child: Text('Please add new customers'),
          );
        }
      },
    ));
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

  _fab() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showFab ? 1 : 0,
        child: FloatingActionButton.extended(
          onPressed: () {
            _showDialog();
          },
          label: const Icon(Icons.add),
        ),
      ),
    );
  }

  navToCustomerDetails({
    required customerName,
    required ifsell,
  }) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomerDetailsScreen(
              customer: customerName,
              ifsell: ifsell,
            )));
  }

  navToPop() {
    Navigator.pop(context);
  }
}
