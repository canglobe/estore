import 'dart:io';

import 'package:estore/constants.dart';
import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/widgets/widgets.dart';

import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  final bool image;
  final String quantity;
  final String productname;

  const ProductDetailPage({
    super.key,
    required this.index,
    required this.image,
    required this.quantity,
    required this.productname,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  String selectedQuantity = '1';
  List? persons;
  bool ifsell = false;
  String? quan;

  var numbers = ['1', '2', '3', '4', '5'];

  getData() async {
    var productsHistory = await localdb.get('productsHistory') ?? {};

    return productsHistory[widget.productname];
  }

  getQuantity(productname) async {
    Map productsDetails = await localdb.get('productsDetails') ?? {};
    String quantity = productsDetails[productname]['quantity'];
    return quantity;
  }

  getNames() async {
    List personsNames = localdb.get('personsNames') ?? [];

    setState(() {
      persons = personsNames;
    });
  }

  @override
  void initState() {
    super.initState();
    getNames();
  }

  save() async {
    Map productsHistory = await localdb.get('productsHistory') ?? {};
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    Map productsDetails = await localdb.get('productsDetails') ?? {};
    List personsNames = await localdb.get('personsNames') ?? [];

    var date = DateTime.now().toString().substring(0, 22);

    if (!personsNames.contains(nameController.text)) {
      personsNames.add(nameController.text);
      await localdb.put('personsNames', personsNames);
    } else {
      //
    }

    if (!productsHistory.containsKey(widget.productname)) {
      productsHistory[widget.productname] = {};
      productsHistory[widget.productname][date] = {
        'person': nameController.text,
        'quantity': quantityController.text,
      };
      await localdb.put('productsHistory', productsHistory);
    } else {
      productsHistory[widget.productname][date] = {
        'person': nameController.text,
        'quantity': quantityController.text,
      };

      await localdb.put('productsHistory', productsHistory);
    }

    if (!personsHistory.containsKey(nameController.text)) {
      personsHistory[nameController.text] = {};
      personsHistory[nameController.text][date] = {
        'product': widget.productname,
        'quantity': quantityController.text,
      };
      await localdb.put('personsHistory', personsHistory);
    } else {
      personsHistory[nameController.text][date] = {
        'product': widget.productname,
        'quantity': quantityController.text,
      };
      await localdb.put('personsHistory', personsHistory);
    }

    var quantity = productsDetails[widget.productname]['quantity'];
    int qty = int.parse(quantity) - int.parse(quantityController.text);
    productsDetails[widget.productname]['quantity'] = qty.toString();
    await localdb.put('productsDetails', productsDetails);

    setState(() {
      ifsell = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productname,
          style: mystyle(25, bold: true),
        ),
        actions: [
          //
          TextButton(
            onPressed: () {},
            child: const Text('Edit'),
          ),
        ],
      ),
      body: bodyContent(context),
    );
  }

  Padding bodyContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(flex: 3, child: ifsell != true ? page1() : page2(context)),
          ifsell != true ? history() : const Center(),
        ],
      ),
    );
  }

  Column page1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: widget.image != false
                  ? Image.file(
                      File('${imagePath + widget.productname}.png'),
                      fit: BoxFit.fill,
                    )
                  : const Center(child: Icon(Icons.image)),
            )),
        const Divider(),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder(
                  future: getQuantity(widget.productname),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    return snapshot.hasData
                        ? Text(
                            snapshot.data.toString(),
                            style: mystyle(
                              36,
                              bold: true,
                            ),
                          )
                        : const SizedBox();
                  }),
              myButton(
                  onPressed: () async {
                    quantityController.text = selectedQuantity;
                    priceController.text =
                        await localdb.get('productsDetails')[widget.productname]
                                ['price'] ??
                            {};

                    setState(() {
                      ifsell = true;
                    });
                  },
                  child: Text(
                    'Sell',
                    style: mystyle(20),
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Card page2(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SizedBox(
                      // width: ScreenSize(context, false, 55),
                      child: DropdownMenu(
                    controller: nameController,
                    dropdownMenuEntries: persons!.map((e) {
                      return DropdownMenuEntry(value: e, label: e);
                    }).toList(),
                  )),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Select Name Here',
                    style: mystyle(14),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Customer Name',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: DropdownMenu(
                    width: ScreenSize(context, false, 43),
                    initialSelection: numbers[0],
                    label: const Text('Quantity'),
                    dropdownMenuEntries: numbers.map((e) {
                      return DropdownMenuEntry(value: e, label: e);
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        //
                        quantityController.text = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 75,
            ),
            myButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    save();
                    setState(() {
                      //
                    });
                  } else {}
                },
                child: myText(
                  text: 'Sell',
                  size: 20.0,
                ))
          ],
        ),
      ),
    );
  }

  Expanded history() {
    return Expanded(
      flex: 5,
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //
          //
          //

          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List keys = [];
            Map snap = snapshot.data;

            for (var x in snap.keys) {
              keys.add(x);
            }
            keys.sort();
            keys = keys.reversed.toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 20,
                  child: GestureDetector(
                    onTap: () {
                      // snap.remove(keys[index]);
                      // var ldb = localdb.get('ldb') ?? {};
                      // ldb[widget.productname]['history'] = snap;
                      // setState(() {});
                    },
                    child: ListTile(
                      trailing: Text(
                        snap[keys[index]]['person'],
                        style: mystyle(20, bold: true),
                      ),
                      leading: SizedBox(
                        width: ScreenSize(context, false, 45),
                        child: Row(
                          children: [
                            Text(
                              keys[index].toString().substring(0, 10),
                              style: mystyle(20, bold: true),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text('/'),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              snap[keys[index]]['quantity'],
                              style: mystyle(23),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: keys.length,
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
}
