import 'package:estore/hive/hivebox.dart';
import 'package:estore/hive/store_io_hive.dart';
import 'package:estore/main.dart';
import 'package:estore/utils/screen_size.dart';
import 'package:estore/views/base_tabbar.dart';
import 'package:estore/widgets/custom_tile.dart';
import 'package:estore/widgets/my_widgets.dart';

import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String customer;
  final bool ifsell;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
    required this.ifsell,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  String selectedQuantity = '1';
  String err = '';
  List? products;
  String? selectedproduct;
  List<String> numbers = ['1', '2', '3', '4', '5'];
  bool? ifsell;

  productsList() async {
    List productNames = [];
    Map productdetails = await hiveDb.getProductDetails();
    productdetails.forEach(
      (key, value) {
        productNames.add(key);
      },
    );
    priceController.text =
        await localdb.get('productDetails')[productNames[0]]['price'] ?? '';
    quantityController.text = selectedQuantity;
    setState(() {
      products = productNames;
      selectedproduct = productNames.isNotEmpty ? productNames[0] : '';
    });
  }

  @override
  void initState() {
    productsList();
    ifsell = widget.ifsell;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(widget.customer),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you wish to delete this customer?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              List customers = await hiveDb.getPersonsNames();

                              customers.remove(widget.customer);

                              await hiveDb.putPersonsNames(customers);

                              navigationToSplash();
                            },
                            child: const Text(
                              "DELETE",
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            )),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("CANCEL"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          ifsell != true
              ? _sellHistory()
              : products!.isNotEmpty
                  ? _sell(context)
                  : _addProduct(),
        ],
      ),
      floatingActionButton: _fab(context),
    );
  }

  _sell(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: DropdownMenu(
                  width: screenSize(context, isHeight: false, percentage: 87),
                  initialSelection: products![0],
                  leadingIcon: const Icon(Icons.category),
                  label: Text(
                    'Product Name',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  dropdownMenuEntries:
                      products!.map<DropdownMenuEntry<String>>((value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                  onSelected: (value) async {
                    priceController.text = await localdb
                            .get('productDetails')[selectedproduct]['price'] ??
                        '';
                    setState(() {
                      selectedproduct = value as String?;
                    });
                  },
                  textStyle: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Price',
                          prefixIcon: Icon(Icons.currency_rupee_rounded),
                        ),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: DropdownMenu(
                        width: screenSize(context,
                            isHeight: false, percentage: 43),
                        initialSelection: numbers[0],
                        label: const Text('Quantity'),
                        dropdownMenuEntries: numbers.map((e) {
                          return DropdownMenuEntry(value: e, label: e);
                        }).toList(),
                        onSelected: (value) {
                          setState(() {
                            selectedQuantity = value!;
                            quantityController.text = selectedQuantity;
                          });
                        },
                        leadingIcon: const Icon(Icons.keyboard),
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myButton(
                      onPressed: () {
                        setState(() {
                          ifsell = false;
                        });
                      },
                      child: const Text(
                        'Back',
                      )),
                  myButton(
                      onPressed: () async {
                        var value = await hiveIO.storeSoldData(
                            widget.customer,
                            selectedproduct!,
                            priceController.text,
                            quantityController.text);
                        if (value == 1) {
                          setState(() {});
                          ifsell = false;
                        }
                      },
                      child: const Text(
                        'Sell',
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addProduct() {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BaseTapBar()));
          },
          child: const Text('First add any one of product')),
    );
  }

  _sellHistory() {
    return Expanded(
      child: FutureBuilder(
        future: hiveDb.getPersonsHistory(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.data.isNotEmpty &&
              snapshot.data[widget.customer] != null) {
            List keys = [];
            Map snap = snapshot.data[widget.customer];

            for (var x in snap.keys) {
              keys.add(x);
            }

            keys.sort();
            keys = keys.reversed.toList();

            return Padding(
              padding: const EdgeInsets.only(left: 9, right: 9),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = keys[index];
                  key =
                      '${key.substring(8, 10)}-${key.substring(5, 7)}-${key.substring(2, 4)}';
                  return Dismissible(
                    key: ValueKey(keys[index]),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this item?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("DELETE")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      var value = await hiveIO.deleteSoldData(
                          selectedproduct!, keys[index]);
                      if (value == 1) {
                        snap.remove(keys[index]);
                        setState(() {});
                      }
                    },
                    child: Column(
                      children: [
                        customTile(context,
                            date: ' $key',
                            name: snap[keys[index]]['product'],
                            price: snap[keys[index]]['price'].toString(),
                            quantity: snap[keys[index]]['quantity']),
                        // const Divider(),
                      ],
                    ),
                  );
                },
                itemCount: keys.length,
              ),
            );
          } else {
            return const Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.info),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'Still Product Was Not Sell',
                  // style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ));
          }
        },
      ),
    );
  }

  _fab(context) {
    return ifsell != true
        ? FloatingActionButton.extended(
            onPressed: () async {
              setState(() {
                ifsell = true;
              });
            },
            label: Text(
              'Sell',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          )
        : const Center();
  }

  navigationToSplash() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (c) => false);
  }
}
