// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:estore/hive/hivebox.dart';
import 'package:estore/hive/store_io_hive.dart';

import 'package:estore/views/products/product_update.dart';
import 'package:estore/utils/screen_size.dart';
import 'package:estore/widgets/custom_tile.dart';
import 'package:estore/widgets/my_widgets.dart';

import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  final bool image;
  final String price;
  final String quantity;
  final String productname;
  final bool ifsell;

  const ProductDetailPage({
    super.key,
    required this.index,
    required this.image,
    required this.quantity,
    required this.productname,
    required this.price,
    required this.ifsell,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  List? persons;
  List<String> names = [];
  String selectedQuantity = '1';
  var numbers = ['1', '2', '3', '4', '5'];
  bool? ifsell;
  bool? haveStock;
  HiveIO hiveIO = HiveIO();

  getData() async {
    var productHistory = await hiveDb.getProductHistory();
    var quantity = await getProductData(needData: 'quantity') ?? '0';
    quantity != '0' ? haveStock = false : haveStock = true;
    return productHistory[widget.productname];
  }

  getProductData({required String needData}) async {
    // in here needData ['quantity' or 'price' ]
    Map data = await hiveDb.getProductDetails() ?? '';

    switch (needData) {
      case 'quantity':
        return data[widget.productname]['quantity'];

      case 'price':
        return data[widget.productname]['price'];
      case '':
        return '0';
    }
  }

  getNames() async {
    List<String> namess = [];
    List customers = await hiveDb.getPersonsNames();
    quantityController.text = selectedQuantity;
    priceController.text = await getProductData(needData: 'price');

    for (var element in customers) {
      namess.add(element);
    }
    setState(() {
      persons = customers;
      names = namess;
    });
  }

  @override
  void initState() {
    getNames();
    ifsell = widget.ifsell;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(
          widget.productname,
        ),
        actions: [
          ifsell != true
              ? IconButton(
                  onPressed: () async {
                    navToProductUpdate();
                  },
                  icon: const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                  ),
                  tooltip: 'Update',
                )
              : const Center(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 3, child: ifsell != true ? _sellHistory() : _sell(context)),
        ],
      ),
      floatingActionButton:
          haveStock != true ? _fab(context) : const SizedBox(),
    );
  }

  _sell(context) {
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
              RawAutocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return names.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Customer Name',
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(15),
                        width: 18,
                        child: const Icon(Icons.person),
                      ),
                    ),
                    focusNode: focusNode,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                      nameController.text = textEditingController.text;
                    },
                    onChanged: (value) {
                      nameController.text = value;
                    },
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                                nameController.text = option;
                              },
                              child: ListTile(
                                title: Text(option),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
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
                      width:
                          screenSize(context, isHeight: false, percentage: 43),
                      initialSelection: numbers[0],
                      label: const Text('Quantity'),
                      dropdownMenuEntries: numbers.map((e) {
                        return DropdownMenuEntry(value: e, label: e);
                      }).toList(),
                      leadingIcon: const Icon(Icons.keyboard),
                      onSelected: (value) {
                        setState(() {
                          selectedQuantity = value!;
                          quantityController.text = selectedQuantity;
                        });
                      },
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  myButton(
                      onPressed: () async {
                        setState(() {
                          ifsell = false;
                        });
                      },
                      child: myText(
                        text: 'Back',
                        size: 20.0,
                      )),
                  myButton(
                      onPressed: () async {
                        if (nameController.text.isNotEmpty) {
                          var value = await hiveIO.storeSoldData(
                            nameController.text,
                            widget.productname,
                            priceController.text,
                            quantityController.text,
                          );
                          if (value == 1) {
                            setState(() {});
                            ifsell = false;
                          }
                        } else {}
                      },
                      child: myText(
                        text: 'Sell',
                        size: 20.0,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _sellHistory() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            width: 500,
            child: Stack(
              alignment: Alignment.center,
              children: [
                FutureBuilder(
                    future: getProductData(needData: 'quantity'),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      return snapshot.hasData
                          ? Text(
                              'Current Stock: ${snapshot.data.toString()}',
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          : const SizedBox();
                    }),
              ],
            ),
          ),
        ),
        const Divider(),
        _history(),
      ],
    );
  }

  _history() {
    return Expanded(
      flex: 9,
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List keys = [];
            Map snap = snapshot.data;

            for (String x in snap.keys) {
              keys.add(x);
              if (keys.contains(x)) {
                //
              } else {
                keys.add(x);
              }
            }
            keys.sort();
            keys = keys.reversed.toList();
            return Padding(
              padding: const EdgeInsets.only(left: 9, right: 9),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  String key = keys[index];
                  key =
                      '${key.substring(8, 10)}-${key.substring(5, 7)}-${key.substring(0, 4)}';

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
                                    child: const Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
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
                        // deleteHistory(index, keys, snap);
                        var value = await hiveIO.deleteSoldData(
                          widget.productname,
                          keys[index],
                        );
                        if (value == 1) {
                          snap.remove(keys[index]);
                          setState(() {});
                        }
                      },
                      child: Column(
                        children: [
                          customTile(context,
                              date: ' $key',
                              name: snap[keys[index]]['customer'],
                              price: snap[keys[index]]['price'].toString(),
                              quantity: snap[keys[index]]['quantity']),
                        ],
                      ));
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
                Text('Still Product Was Not Sell'),
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
              // var quantity = await getProductData(needData: 'quantity');
              // var price = await getProductData(needData: 'price');

              // if (quantity != 0) {
              //   quantityController.text = selectedQuantity;
              //   priceController.text = price;
              // } else {}
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

  void navToProductUpdate() async {
    var refresh = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ProductUpdate(
              productname: widget.productname,
              price: widget.price,
              quantity: widget.quantity,
              image: widget.image,
            )));

    setState(() {});
  }
}
