import 'dart:io';
import 'package:estore/constants.dart';
import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  final String image;
  final String qty;
  final String productname;

  const ProductDetailPage({
    super.key,
    required this.index,
    required this.image,
    required this.qty,
    required this.productname,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();

  String dropdownValue = '1';
  List? names;
  bool ifsell = false;
  String? quan;

  var numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  getData(productname) async {
    var ldb = localdb.get('ldb') ?? {};
    Map history = ldb[productname]['history'];
    return history;
  }

  getQuantity(productname) async {
    var ldb = localdb.get('ldb') ?? {};
    String Q = ldb[productname]['quantity'];
    return Q;
  }

  getNames() async {
    List keys = [];
    Map ldbcc = localdb.get('ldbcc') ?? {};
    for (var element in ldbcc.keys) {
      keys.add(element);
    }
    setState(() {
      names = keys;
    });
  }

  @override
  void initState() {
    super.initState();
    getNames();
    getQuantity(widget.productname);
  }

  sellboxshow(context) async {
    quantityController.text = dropdownValue;
    priceController.text =
        await localdb.get('ldb')[widget.productname]['price'] ?? {};

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                //
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      SizedBox(
                          width: ScreenSize(context, false, 50),
                          child: DropdownMenu(
                            controller: nameController,
                            dropdownMenuEntries: names!.map((e) {
                              return DropdownMenuEntry(value: e, label: e);
                            }).toList(),
                          )),
                      const TextField(),
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
                            width: 12,
                          ),
                          Expanded(
                            child: DropdownMenu(
                              width: ScreenSize(context, false, 29),
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
                    ],
                  ),
                ),
                //
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Done'),
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  storeData(widget.productname);
                } else {
                  //
                }
              },
            ),
          ],
        );
      },
    );
  }

  storeData(String productname) async {
    try {
      var date = DateTime.now().toString().substring(0, 22);

      var ldb = await localdb.get('ldb') ?? {};

      Map dat = ldb[productname] ?? {};
      dat['history'][date] = {
        'name': nameController.text,
        'qty': quantityController.text,
        'price': priceController.text,
      };
      var q = ldb[productname]['quantity'];

      q = int.parse(q) - int.parse(quantityController.text);

      ldb[productname]['quantity'] = q.toString();

      await localdb.put('ldb', ldb);

      Map ldbcc = await localdb.get('ldbcc') ?? {nameController.text: {}};
      if (ldbcc.containsKey(nameController.text)) {
        ldbcc[nameController.text][date] = {
          'name': productname,
          'qty': quantityController.text,
          'price': priceController.text,
        };
      } else {
        ldbcc[nameController.text] = {};
        ldbcc[nameController.text][date] = {
          'name': productname,
          'qty': quantityController.text,
          'price': priceController.text,
        };
      }

      await localdb.put('ldbcc', ldbcc);
    } catch (e) {
      print(e);
    }
    setState(() {
      nameController.clear();

      priceController.clear();
    });

    // Navigator.of(context).pop();
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ifsell != true
                  ? Column(
                      children: [
                        Expanded(
                            flex: 2,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: widget.image != ''
                                  ? Image.file(File(widget.image))
                                  : const Icon(Icons.image),
                            )),
                        const Divider(),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FutureBuilder(
                                  future: getQuantity(widget.productname),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot) {
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
                                    quantityController.text = dropdownValue;
                                    priceController.text = await localdb
                                                .get('ldb')[widget.productname]
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
                    )
                  : Card(
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
                                    dropdownMenuEntries: names!.map((e) {
                                      return DropdownMenuEntry(
                                          value: e, label: e);
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
// Already a Customer?\n
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
                                      return DropdownMenuEntry(
                                          value: e, label: e);
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
                                    storeData(widget.productname);
                                    setState(() {
                                      ifsell = false;
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
                    ),
            ),
            const Divider(),
            ifsell != true
                ? Expanded(
                    flex: 5,
                    child: FutureBuilder(
                      future: getData(widget.productname),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData && snapshot.data.isNotEmpty) {
                          List keys = [];
                          Map snap = snapshot.data;

                          // snap.forEach((key, value) {
                          //   keys.add(key);
                          // });
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
                                    isThreeLine: true,
                                    trailing: Text(
                                      snap[keys[index]]['name'],
                                      style: mystyle(20, bold: true),
                                    ),
                                    subtitle: const SizedBox(),
                                    leading: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          keys[index]
                                              .toString()
                                              .substring(0, 10),
                                          style: mystyle(
                                            20,
                                            bold: true,
                                          ),
                                        ),
                                        // const Text('/'),
                                        // Text(
                                        //   snap[keys[index]]['qty'],
                                        //   style: mystyle(23, bold: true),
                                        // ),
                                      ],
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
                  )
                : const Center(),
          ],
        ),
      ),
    );
  }
}
