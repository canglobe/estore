import 'package:estore/constants.dart';

import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/widgets/widgets.dart';

import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String person;

  const CustomerDetailsScreen({
    super.key,
    required this.person,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  String? selectedproduct;

  save1() async {
    try {
      Map productsHistory = await localdb.get('productsHistory') ?? {};
      Map personsHistory = await localdb.get('personsHistory') ?? {};
      var date = DateTime.now().toString().substring(0, 22);

      Map map1 = productsHistory[selectedproduct] ?? {selectedproduct: {}};
      map1[date] = {
        'person': widget.person,
        'quantity': quantityController.text,
      };

      Map map2 = personsHistory[widget.person] ?? {widget.person: {}};
      map2[date] = {
        'product': selectedproduct,
        'quantity': quantityController.text,
      };

      await localdb.put('productsHistory', productsHistory);
      await localdb.put('personsHistory', personsHistory);
    } catch (e) {
//
    }
  }

  save() async {
    Map productsHistory = await localdb.get('productsHistory') ?? {};
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    var date = DateTime.now().toString().substring(0, 22);

    if (!productsHistory.containsKey(selectedproduct)) {
      productsHistory[selectedproduct] = {};
      productsHistory[selectedproduct][date] = {
        'person': widget.person,
        'quantity': quantityController.text,
      };
      await localdb.put('productsHistory', productsHistory);
    } else {
      productsHistory[selectedproduct][date] = {
        'person': widget.person,
        'quantity': quantityController.text,
      };
      await localdb.put('productsHistory', productsHistory);
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

    Map productsDetails = await localdb.get('productsDetails') ?? {};
    var quantity = productsDetails[selectedproduct]['quantity'];
    int qty = int.parse(quantity) - int.parse(quantityController.text);
    productsDetails[selectedproduct]['quantity'] = qty.toString();
    await localdb.put('productsDetails', productsDetails);
  }

  String err = '';

  getData() async {
    Map personsHistory = await localdb.get('personsHistory') ?? {};
    print(personsHistory);
    print(widget.person);

    return personsHistory;
  }

  removeData(index, keys, snap) async {
    Map productsHistory = await localdb.get('productsHistory') ?? {};

    var personsHistory = await localdb.get('personsHistory') ?? {};

    Map history = personsHistory[widget.person];

    var product = history[keys[index]]['product'];

    Map historypr = productsHistory[product];
    historypr.remove(keys[index]);
    history.remove(keys[index]);
    ;

    productsHistory[product] = historypr;
    personsHistory[widget.person] = history;

    await localdb.put('productsHistory', productsHistory);
    await localdb.put('personsHistory', personsHistory);
    snap.remove(keys[index]);
  }

  var numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  List? products;

  bool ifselling = false;

  final quantityController = TextEditingController();

  productsList() async {
    List productsNames = await localdb.get('productsNames') ?? [];

    setState(() {
      products = productsNames;
      selectedproduct = productsNames[0];
    });
  }

  @override
  void initState() {
    productsList();
    super.initState();
  }

  final pr1 = TextEditingController();

  sellboxshow(context) async {
    productsList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Please Confirm',
                  textScaleFactor: 1.3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            OutlinedButton(
              onPressed: save,
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            //
            IconButton(
                onPressed: () async {
                  //
                  List personsNames = await localdb.get('personsNames') ?? {};
                  print(personsNames);
                  personsNames.remove(widget.person);

                  await localdb.put('personsNames', personsNames);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (c) => false);
                },
                icon: Icon(Icons.delete_forever_outlined))
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            ifselling != true ? page1() : page2(context),
            const SizedBox(height: 15),
            const Divider(),
            ifselling != true ? history() : const Center()
          ],
        ));
  }

  Row page1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          widget.person,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        myButton(
            onPressed: () {
              setState(() {
                ifselling = true;
              });
            },
            child: Text(
              'Sell',
              style: Theme.of(context).textTheme.displaySmall,
            ))
      ],
    );
  }

  Column page2(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              child: DropdownMenu(
                width: ScreenSize(context, false, 45),
                label: selectedproduct != null
                    ? Text(
                        selectedproduct!.toString(),
                        style: mystyle(20),
                      )
                    : Text(
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
                    selectedproduct = value;
                  });
                },
                textStyle: mystyle(20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              // width: ScreenSize(context, false, 43),
              child: DropdownMenu(
                controller: quantityController,
                width: ScreenSize(context, false, 45),
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
                    //
                    quantityController.text = value!;
                  });
                },
                textStyle: mystyle(20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
        const SizedBox(
          height: 45,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            myButton(
                onPressed: () {
                  setState(() {
                    ifselling = false;
                  });
                },
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.displaySmall,
                )),
            myButton(
                onPressed: () {
                  save();
                  setState(() {
                    ifselling = false;
                  });
                },
                child: Text(
                  'Sell',
                  style: Theme.of(context).textTheme.displaySmall,
                )),
          ],
        )
      ],
    );
  }

  Widget history() {
    return Expanded(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          print(snapshot.data);
          if (snapshot.hasData &&
              snapshot.data.isNotEmpty &&
              snapshot.data != null) {
            List keys = [];
            Map snap = snapshot.data[widget.person];

            snap.keys;
            for (var x in snap.keys) {
              keys.add(x);
            }

            keys.sort();
            keys = keys.reversed.toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  elevation: 9,
                  child: Dismissible(
                    key: ValueKey(keys[index]),
                    onDismissed: (direction) {
                      removeData(index, keys, snap);
                    },
                    child: ListTile(
                      // isThreeLine: true,
                      // trailing: Text(
                      //   snap[keys[index]]['product'].toString(),
                      //   style: Theme.of(context).textTheme.displaySmall,
                      // ),
                      trailing: Text(
                        '${snap[keys[index]]['product']} ( ${snap[keys[index]]['quantity']} )',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      // subtitle: const SizedBox(),
                      leading: SizedBox(
                        width: ScreenSize(context, false, 45),
                        child: Text(
                          keys[index].toString().substring(0, 16),
                          style: Theme.of(context).textTheme.displaySmall,
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
