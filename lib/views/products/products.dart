import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:estore/utils/screen_size.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/constants/constants.dart';
import 'package:estore/views/products/product_plus.dart';
import 'package:estore/views/products/product_details.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool ifintialloading = true;
  String? prname;
  List? products;
  bool? reFresh;
  Map? ldbs;
  bool showFab = true;

  getData() async {
    Map productDetails = await HiveDB().getProductDetails();
    return productDetails;
  }

  checkImageExists(productname) async {
    var exists =
        await File('${imagePath + productname}.jpg').exists() ? true : false;

    return exists;
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
            const Divider(),
            _productsList(),
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
        padding: const EdgeInsets.only(left: 9, top: 9, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Products',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  _productsList() {
    return Expanded(
      child: FutureBuilder(
        future: hiveDb.getProductDetails(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            List products = [];
            Map snap = snapshot.data;
            for (var key in snap.keys) {
              products.add(key);
            }
            products.sort();
            return Container(
                padding: const EdgeInsets.all(5),
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(2),
                    child: GestureDetector(
                      onTap: () => navToProductDetail(
                          context: context,
                          index: index,
                          snap: snap,
                          products: products,
                          ifsell: false),
                      child: SizedBox(
                        height: screenSize(context,
                            isHeight: true, percentage: 16.5),
                        child: Card(
                          elevation: 0.3,
                          color: cardBgColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(9))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Show image or Product name
                                SizedBox(
                                  width: screenSize(context,
                                      isHeight: false, percentage: 47),
                                  child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5)),
                                      child: FutureBuilder(
                                          future:
                                              checkImageExists(products[index]),
                                          builder: (context, snapshot) {
                                            var snap = snapshot.data;

                                            if (snap != true) {
                                              return Container(
                                                color: primaryColor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        products[index]
                                                            .toString()
                                                            .toUpperCase(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .displaySmall),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Image.file(
                                                File(
                                                    '${imagePath + products[index]}.jpg'),
                                                fit: BoxFit.fill,
                                              );
                                            }
                                          })),
                                ),
                                const SizedBox(width: 5),
                                // Show available stock
                                SizedBox(
                                  width: screenSize(context,
                                      isHeight: false, percentage: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Stock',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall,
                                      ),
                                      Text(
                                        snap[products[index]]['quantity']
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: textLightColor,
                                            fontSize: snap[products[index]]
                                                            ['quantity']
                                                        .toString()
                                                        .length >
                                                    6
                                                ? 18
                                                : 24,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                // right arrow icon button
                                SizedBox(
                                  width: screenSize(context,
                                      isHeight: false, percentage: 12),
                                  child: IconButton(
                                      onPressed: () {
                                        snap[products[index]]['quantity'] != '0'
                                            ? navToProductDetail(
                                                context: context,
                                                index: index,
                                                snap: snap,
                                                products: products,
                                                ifsell: true)
                                            : ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "You won't sell.Your Stock has Zero (0).")));
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: textLightColor,
                                      )),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                  itemCount: products.length,
                ));
          } else {
            return const Center(
              child: Text('Please add some products'),
            );
          }
        },
      ),
    );
  }

  _fab() {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      offset: showFab ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showFab ? 1 : 0,
        child: FloatingActionButton.extended(
          onPressed: () => navToNewProduct(context),
          label: const Icon(Icons.add),
        ),
      ),
    );
  }

  // navigation routes
  navToProductDetail({
    required BuildContext context,
    required int index,
    required Map<dynamic, dynamic> snap,
    required List<dynamic> products,
    required bool ifsell,
  }) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => ProductDetailPage(
                  index: index,
                  price: snap[products[index]]['price'],
                  image: snap[products[index]]['image'],
                  quantity: snap[products[index]]['quantity'],
                  productname: products[index],
                  ifsell: ifsell,
                )))
        .then((value) {
      setState(() {});
    });
  }

  navToNewProduct(context) async {
    var refresh = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const NewProduct()));
    setState(() {
      reFresh = refresh;
    });
  }

  navToSplash() {
    Navigator.pushNamed(context, '/');
  }
}
