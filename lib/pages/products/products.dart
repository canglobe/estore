import 'dart:io';
import 'package:estore/constants.dart';
import 'package:estore/main.dart';
import 'package:estore/pages/products/newproduct.dart';
import 'package:flutter/material.dart';
import 'package:estore/pages/products/productdetails.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String? prname;
  List? products;
  bool? reFresh;
  Map? ldbs;

  getData() async {
    Map ldb = await localdb.get('ldb') ?? {};

    return ldb;
  }

  deleteData(key) async {
    Map ldb = await localdb.get('ldb') ?? {};
    ldb.remove(key);
    await localdb.put('ldb', ldb);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                'My Products',
                style: mystyle(
                  22,
                ),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                //
                if (snapshot.hasData && snapshot.data.isNotEmpty) {
                  Map snap = snapshot.data;
                  List products = [];
                  for (var key in snap.keys) {
                    products.add(key);
                  }

                  products.sort();
                  return Container(
                      child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(3),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                      index: index,
                                      image: snap[products[index]]['imagedir'],
                                      qty: snap[products[index]]['quantity'],
                                      productname: products[index])))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        child: Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Card(
                                child: Column(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                        ),
                                        child: snap[products[index]]
                                                    ['imagedir'] !=
                                                ''
                                            ? Image.file(
                                                File(snap[products[index]]
                                                    ['imagedir']),
                                                fit: BoxFit.fill,
                                              )
                                            : const Center(
                                                child: Icon(Icons.image)),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 3),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            snap[products[index]]['quantity'],
                                            overflow: TextOverflow.ellipsis,
                                            style: mystyle(20, bold: true),
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
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  top: 0,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    products[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: mystyle(
                                      23,
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
                  ));
                } else {
                  return progress();

                  // return Align(
                  //     alignment: Alignment.topCenter,
                  //     child: LinearProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigate(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  bool ifintialloading = true;
  Widget progress() {
    loading();
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
              Text('Still Product Was Not Added'),
            ],
          ));
  }

  loading() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      ifintialloading = false;
    });
  }

  navigate(context) async {
    var refresh = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewProduct()));
    setState(() {
      reFresh = refresh;
    });
  }

  getImage() async {
    // FirebaseStorage storage = FirebaseStorage.instance;
    // var img = await storage.ref('images').getDownloadURL();
    // setState(() {
    // _imgurl = img;
    // });
  }

  // getData() async {
  //   DatabaseReference db = await FirebaseDatabase.instance.ref('productName');
  //   DataSnapshot snap = await db.get();
  //   print(snap.value);
  //   setState(() {
  //     prname = snap.value.toString();
  //   });
  // }
}


// Padding(
                                            //   padding: const EdgeInsets.all(3),
                                            //   child: Align(
                                            //     alignment: Alignment.topRight,
                                            //     child: CircleAvatar(
                                            //       backgroundColor: Colors.white,
                                            //       child: PopupMenuButton(
                                            //         itemBuilder: (context) => [
                                            //           PopupMenuItem(
                                            //             onTap: () {
                                            //               navigate(context);
                                            //             },
                                            //             child: const Text(
                                            //               "Change Image",
                                            //             ),
                                            //           ),
                                            //           PopupMenuItem(
                                            //             onTap: () =>
                                            //                 navigate(context),
                                            //             child: const Text(
                                            //               "Edit",
                                            //             ),
                                            //           ),
                                            //           PopupMenuItem(
                                            //             onTap: () {
                                            //               deleteData(
                                            //                   products[index]);
                                            //             },
                                            //             child: const Text(
                                            //               'Delete',
                                            //             ),
                                            //           ),
                                            //         ],
                                            //         onSelected: (item) => {
                                            //           // print(item)
                                            //           //
                                            //         },
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),