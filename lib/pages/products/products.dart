// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';
import 'package:estore/constants.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/main.dart';
import 'package:estore/pages/products/productdetails.dart';

import 'package:estore/pages/products/productplus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:estore/pages/products/productsDetails.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref('ldb');
  bool ifintialloading = true;
  String? prname;
  List? products;
  bool? reFresh;
  Map? ldbs;

  getData() async {
    Map productsDetails = await localdb.get('productsDetails');
    print(productsDetails);
    return productsDetails;
  }

  deleteData(key) async {
    Map ldb = await HiveBox().ldbGet();
    ldb.remove(key);
    await localdb.put('ldb', ldb);
    setState(() {});
  }

  navigation(context) async {
    var refresh = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewProduct()));
    setState(() {
      reFresh = refresh;
    });
  }

  bool activeConnection = false;
  String T = "";
  Future checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          activeConnection = true;
          T = "Turn off the data and repress again";
        });
      }
    } on SocketException catch (_) {
      setState(() {
        activeConnection = false;
        T = "Turn On the data and repress again";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text('I Think Your Internet Was Off..'),
          duration: const Duration(seconds: 12),
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 150,
              left: 10,
              right: 10),
        ),
      );
    }
  }

  @override
  void initState() {
    checkUserConnection();
    super.initState();
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  func() {
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 0,
        key: _refreshIndicatorKey,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 3), func());
        },
        child: Column(
          children: [
            _title2(),
            const Divider(),
            _productsWidget(),
          ],
        ),
      ),
      floatingActionButton: fab(),
    );
  }

  Widget _title2() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          'My Products',
          style: Theme.of(context).textTheme.displaySmall,
          // mystyle(
          //   20,
          //   color: ,
          // ),
        ),
      ),
    );
  }

  Widget _productsWidget() {
    return Expanded(
      child: FutureBuilder(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            //
            //
            //
            List products = [];

            Map snap = snapshot.data;

            for (var key in snap.keys) {
              products.add(key);
            }

            products.sort();
            return Padding(
              padding: const EdgeInsets.all(9),
              child: Container(
                  child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(4.5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                  index: index,
                                  price: snap[products[index]]['price'],
                                  image: snap[products[index]]['image'],
                                  quantity: snap[products[index]]['quantity'],
                                  productname: products[index])))
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: Column(
                      children: [
                        // Padding(padding: EdgeInsets.only(top: 5)),
                        Expanded(
                          flex: 4,
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                    ),
                                    child:
                                        snap[products[index]]['image'] != false
                                            ? Image.file(
                                                File(
                                                    '${imagePath + products[index]}.png'),
                                                fit: BoxFit.fill,
                                              )
                                            : const Center(
                                                child: Icon(Icons.image)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        snap[products[index]]['quantity']
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Card(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  products[index].toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                itemCount: products.length,
              )),
            );
          } else {
            return progress();
          }
        },
      ),
    );
  }

  // bool ifintialloading = true;
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

  Widget fab() {
    return FloatingActionButton(
      onPressed: () => navigation(context),
      child: const Icon(Icons.add),
    );
  }
}
