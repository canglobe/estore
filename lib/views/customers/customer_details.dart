import 'package:estore/constants/constants.dart';
import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/views/base.dart';
import 'package:estore/widgets/widgets.dart';

import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String person;
  final bool ifsell;

  const CustomerDetailsScreen({
    super.key,
    required this.person,
    required this.ifsell,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final quantityController = TextEditingController();

  String err = '';
  List? products;
  String? selectedproduct;
  List<String> numbers = ['1', '2', '3', '4', '5'];
  bool? ifsell;

  getData() async {
    Map personsHistory = await localdb.get('personsHistory') ?? {};

    return personsHistory;
  }

  productsList() async {
    List productNames = [];
    Map productdetails = await hiveDb.getProductDetails();
    productdetails.forEach(
      (key, value) {
        productNames.add(key);
      },
    );
    setState(() {
      products = productNames;
      selectedproduct = productNames.isNotEmpty ? productNames[0] : '';
    });
  }

  save() async {
    Map productHistory = await localdb.get('productHistory') ?? {};
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    var date = DateTime.now().toString().substring(0, 19);

    if (!productHistory.containsKey(selectedproduct)) {
      productHistory[selectedproduct] = {};
      productHistory[selectedproduct][date] = {
        'person': widget.person,
        'quantity': quantityController.text,
      };
      await localdb.put('productHistory', productHistory);
    } else {
      productHistory[selectedproduct][date] = {
        'person': widget.person,
        'quantity': quantityController.text,
      };
      await localdb.put('productHistory', productHistory);
    }

    if (!personsHistory.containsKey(widget.person)) {
      personsHistory[widget.person] = {};
      personsHistory[widget.person][date] = {
        'product': selectedproduct,
        'quantity': quantityController.text,
      };
      await localdb.put('personsHistory', personsHistory);
    } else {
      personsHistory[widget.person][date] = {
        'product': selectedproduct,
        'quantity': quantityController.text,
      };
      await localdb.put('personsHistory', personsHistory);
    }

    Map productDetails = await localdb.get('productDetails') ?? {};
    var quantity = productDetails[selectedproduct]['quantity'];
    int qty = int.parse(quantity) - int.parse(quantityController.text);
    productDetails[selectedproduct]['quantity'] = qty.toString();
    await localdb.put('productDetails', productDetails);
  }

  deleteHistory(index, keys, snap) async {
    Map productdetails = await hiveDb.getProductDetails();
    Map productHistory = await localdb.get('productHistory') ?? {};

    Map personsHistory = await localdb.get('personsHistory') ?? {};
    Map history = personsHistory[widget.person];
    var product = history[keys[index]]['product'];

    bool avl = productdetails.containsKey(product);

    var quant = history[keys[index]]['quantity'];
    if (avl) {
      var qty = productdetails[product]['quantity'];

      var newqty = int.parse(qty) + int.parse(quant);
      productdetails[product]['quantity'] = newqty.toString();
    }
    Map historypr = productHistory[product];

    historypr.remove(keys[index]);
    history.remove(keys[index]);

    productHistory[product] = historypr;
    personsHistory[widget.person] = history;

    await localdb.put('productHistory', productHistory);
    await localdb.put('personsHistory', personsHistory);
    avl ? await hiveDb.putProductDetails(productdetails) : '';
    snap.remove(keys[index]);
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
        title: Text(widget.person),
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
                              List personsNames =
                                  await localdb.get('personsNames') ?? [];

                              personsNames.remove(widget.person);

                              await localdb.put('personsNames', personsNames);

                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (c) => false);
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
    return Column(
      children: [
        const Divider(),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                child: DropdownMenu(
                  width: screenSize(context, isHeight: false, percentage: 70),
                  initialSelection: products![0],
                  label: Text(
                    'Product Name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  dropdownMenuEntries:
                      products!.map<DropdownMenuEntry<String>>((value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      selectedproduct = value as String?;
                    });
                  },
                  textStyle: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                child: DropdownMenu(
                  controller: quantityController,
                  width: screenSize(context, isHeight: false, percentage: 20),
                  initialSelection: numbers[0],
                  label: Text(
                    'Quantity',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  dropdownMenuEntries: numbers.map((e) {
                    return DropdownMenuEntry(value: e, label: e);
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      quantityController.text = value!;
                    });
                  },
                  textStyle: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 45,
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
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
            myButton(
                onPressed: () {
                  save();
                  setState(() {
                    ifsell = false;
                  });
                },
                child: Text(
                  'Sell',
                  style: Theme.of(context).textTheme.labelLarge,
                )),
          ],
        ),
        const SizedBox(
          height: 45,
        ),
      ],
    );
  }

  _addProduct() {
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const BaseScreen()));
          },
          child: const Text('First add any one of product')),
    );
  }

  _sellHistory() {
    return Expanded(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData &&
              snapshot.data.isNotEmpty &&
              snapshot.data[widget.person] != null) {
            List keys = [];
            Map snap = snapshot.data[widget.person];

            for (var x in snap.keys) {
              keys.add(x);
            }

            keys.sort();
            keys = keys.reversed.toList();

            return Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = keys[index];
                  key =
                      '${key.substring(8, 10)}/${key.substring(5, 7)}/${key.substring(2, 4)}';
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
                      deleteHistory(index, keys, snap);

                      setState(() {});
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSize(context,
                              isHeight: true, percentage: 14),
                          child: Card(
                            elevation: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  ' $key',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${snap[keys[index]]['product']} ( ${snap[keys[index]]['quantity']} )',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
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
                  // style: Theme.of(context).textTheme.displayMedium,
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
          )
        : const Center();
  }
}
