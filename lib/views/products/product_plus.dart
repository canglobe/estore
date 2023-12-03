import 'package:estore/hive/hivebox.dart';

import 'package:estore/model/productsmodel.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as im;

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  HiveDB hiveDb = HiveDB();

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  io.File? image;
  bool? isLoading;

  String err = '';

  preCheck() {
    String name = nameController.text.toString();
    String price = priceController.text.toString();
    String qty = quantityController.text.toString();
    // check having all data
    name.isNotEmpty && qty.isNotEmpty && price.isNotEmpty
        ? proceedData(name, qty, price)
        : throwError();
  }

  proceedData(String name, String quantity, String price) async {
    setState(() {
      isLoading = true;
    });
    List productNames = [];
    bool haveImage = image != null ? true : false;
    haveImage != false ? saveImage(io.File(image!.path)) : () {};

    // Get data from local database
    Map productDetails = await hiveDb.getProductDetails() ?? {};
    productNames = await hiveDb.getProductNames() ?? [];

    // productDetails[name] = {
    //   'image': haveImage,
    //   'price': price,
    //   'quantity': quantity,
    // };

    if (!productDetails.containsKey(name)) {
      productDetails.putIfAbsent(
          name,
          () => ProductsMod(
                  name: name,
                  price: price,
                  image: haveImage,
                  quantity: quantity)
              .toMap());
      productNames.add(name);

      await hiveDb.putProductDetails(productDetails);
      await hiveDb.putProductNames(productNames);

      setState(() {
        isLoading = false;
      });

      // Screen pop out
      popOut();
    } else {
      setState(() {
        err = 'Already exists this product';
        isLoading = false;
      });
    }
  }

  popOut() {
    Navigator.pop(context);
  }

  throwError() {
    err = 'Something Missing in Product Details';
    setState(() {});
  }

  pickImageCamera() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    io.File file = io.File(img!.path);

    setState(() {
      err = '';
      image = file;
    });
  }

  pickImageGallery() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    io.File file = io.File(img!.path);

    setState(() {
      err = '';
      image = file;
    });
  }

  Future<io.File> saveImage(io.File file) async {
    String name = nameController.text.toString();
    try {
      var dir = await getExternalStorageDirectory();
      var imagedir =
          await io.Directory('${dir!.path}/images').create(recursive: true);

      im.Image? image = im.decodeImage(file.readAsBytesSync());
      return io.File('${imagedir.path}/$name.png')
        ..writeAsBytesSync(im.encodePng(image!));
    } catch (e) {
      return io.File('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: bodyContent(context),
    );
  }

  bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 25, right: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textfields(context),
            const Divider(),
            _imageSelection(),
            const Divider(),
            err.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(9),
                    child: Text(
                      err,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )
                : const Center(),
            const SizedBox(height: 15),
            _doneButton(),
            const SizedBox(height: 35),
          ],
        ),
      ),
    );
  }

  _textfields(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          'Product Details',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(
          height: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Name',
            //   style: Theme.of(context).textTheme.displaySmall,
            // ),
            const SizedBox(
              height: 3,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                prefixIcon: Icon(Icons.category_rounded),
              ),
              onTap: () {
                setState(() {
                  err = '';
                });
              },
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Price',
                //   style: Theme.of(context).textTheme.displaySmall,
                // ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  // width: ScreenSize(context, false, 33),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Price',
                      prefixIcon: Icon(Icons.currency_rupee_rounded),
                    ),
                    onTap: () {
                      setState(() {
                        err = '';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Quantity',
                //   style: Theme.of(context).textTheme.displaySmall,
                // ),
                const SizedBox(
                  height: 3,
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.keyboard),
                  ),
                  onTap: () {
                    setState(() {
                      err = '';
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  _imageSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 5,
        ),
        image != null
            ? _imageCard()
            : Text(
                'Select Image',
                style: Theme.of(context).textTheme.displayLarge,
              ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 45,
                  width: 113,
                  child: OutlinedButton(
                      onPressed: () {
                        pickImageCamera();
                      },
                      child: const Icon(Icons.camera_alt)),
                ),
                Text(
                  'Camera',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 45,
                  width: 113,
                  child: OutlinedButton(
                      onPressed: () {
                        pickImageGallery();
                      },
                      child: const Icon(Icons.photo)),
                ),
                Text('Gallery',
                    style: Theme.of(context).textTheme.displaySmall),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  _imageCard() {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          'Selected Image',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        SizedBox(
            height: 150,
            width: 300,
            child: Card(
                elevation: 20,
                child: Image.file(
                  io.File(image!.path),
                  fit: BoxFit.fill,
                ))),
      ],
    );
  }

  _doneButton() {
    return SizedBox(
      height: 45,
      width: 90,
      child: ElevatedButton(
        onPressed: () async {
          preCheck();
        },
        child: isLoading != true
            ? Text(
                'Save',
                style: Theme.of(context).textTheme.headlineSmall,
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
