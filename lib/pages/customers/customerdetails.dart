import 'package:estore/constants.dart';
import 'package:estore/hive/hiveinit.dart';
import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:estore/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final String pname;

  const CustomerDetailsScreen({
    super.key,
    required this.pname,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  String? selectedproduct;
  @override
  void initState() {
    productsList();
    super.initState();
  }

  String err = '';
  getData() async {
    Map ldbcc = await localdb.get('ldbcc') ?? {};

    return ldbcc;
  }

  var numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];

  List<String>? products;

  List<String>? nothing = [];

  bool ifselling = false;
  final quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [
            //
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ifselling != true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.pname,
                        style: mystyle(24),
                      ),
                      myButton(
                          onPressed: () {
                            setState(() {
                              ifselling = true;
                            });
                          },
                          child: Text(
                            'Sell',
                            style: mystyle(20),
                          ))
                    ],
                  )
                : Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      style: mystyle(20),
                                    ),
                              dropdownMenuEntries: products!
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
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
                                style: mystyle(20),
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
                      myButton(
                          onPressed: () {
                            // sellboxshow(context);
                            storeData();
                            setState(() {
                              ifselling = false;
                            });
                          },
                          child: Text(
                            'Sell',
                            style: mystyle(20),
                          ))
                    ],
                  ),
            //
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            ifselling != true
                ? Expanded(
                    child: FutureBuilder(
                      future: getData(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData && snapshot.data.isNotEmpty) {
                          List keys = [];
                          Map snap = snapshot.data[widget.pname];
                          snap.keys;
                          for (var x in snap.keys) {
                            keys.add(x);
                          }

                          keys.sort();
                          keys = keys.reversed.toList();

                          return ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  isThreeLine: true,
                                  trailing: Text(
                                    snap[keys[index]]['name'],
                                    style: mystyle(20, bold: true),
                                  ),
                                  subtitle: const SizedBox(),
                                  leading: SizedBox(
                                    width: ScreenSize(context, false, 45),
                                    child: Row(
                                      children: [
                                        Text(
                                          keys[index]
                                              .toString()
                                              .substring(0, 10),
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
                                          snap[keys[index]]['qty'],
                                          style: mystyle(23),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: keys.length,
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  )
                : const Center()
          ],
        ));
  }

  final pr1 = TextEditingController();

  productsList() async {
    List<String> lst = [];
    Map ldb = await HiveBox().ldb();
    for (var element in ldb.keys) {
      lst.add(element);
    }

    setState(() {
      products = lst;
      selectedproduct = lst[0];
    });
    return lst;
  }

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
              child: const Text('Confirm'),
              onPressed: () {
                storeData();
              },
            ),
          ],
        );
      },
    );
  }

  storeData() async {
    var date = DateTime.now().toString().substring(0, 22);
    var ldb = await localdb.get('ldb') ?? {};
    Map ldbcc = await localdb.get('ldbcc') ?? {widget.pname: {}};

    if (selectedproduct!.isNotEmpty) {
      Map dat = ldb[selectedproduct];
      dat['history'][date] = {
        'name': widget.pname,
        'qty': quantityController.text,
        'price': ldb[selectedproduct]['price'],
      };

      var q = ldb[selectedproduct]['quantity'];

      q = int.parse(q) - int.parse(quantityController.text);

      ldb[selectedproduct]['quantity'] = q.toString();

      await localdb.put('ldb', ldb);

      ldbcc[widget.pname][date] = {
        'name': selectedproduct,
        'qty': quantityController.text,
        'price': ldb[selectedproduct]['price'],
      };
      await localdb.put('ldbcc', ldbcc);
    } else {}
  }
}
