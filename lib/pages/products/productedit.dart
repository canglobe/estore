import 'dart:io';

import 'package:estore/constants.dart';

import 'package:estore/main.dart';
import 'package:estore/utils/size.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image/image.dart' as im;

class ProductEdit extends StatefulWidget {
  // final int index;
  final bool image;
  final String price;
  final String quantity;
  final String productname;

  ProductEdit(
      {super.key,
      required this.productname,
      required this.price,
      required this.quantity,
      required this.image});

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  io.File? imageUpdate;
  bool? isLoading;
  bool? image;

  String err = '';

  check() {
    String name = nameController.text.toString();
    String price = priceController.text.toString();
    String qty = quantityController.text.toString();
    name.isNotEmpty && qty.isNotEmpty && price.isNotEmpty
        ? proceedData(name, qty, price)
        : throwError();
  }

  void proceedData(String name, String qty, String price) async {
    setState(() {
      isLoading = true;
    });

    bool haveImage = image != null ? true : false;
    haveImage != false ? saveImage(io.File(imageUpdate!.path)) : () {};
    Map productsDetails = await localdb.get('productsDetails') ?? {};
    List productsNames = await localdb.get('productsNames') ?? [];

    productsDetails[name] = {
      'image': haveImage,
      'price': price,
      'quantity': qty,
    };

    productsNames.add(name);

    await localdb.put('productsDetails', productsDetails);
    await localdb.put('productsNames', productsNames);

    setState(() {
      isLoading = false;
    });
    navigation();
  }

  navigation() {
    Navigator.pop(context, true);
  }

  throwError() {
    err = 'Please Check necessary fields';
    setState(() {});
  }

  pickImageCamera() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    io.File file = io.File(img!.path);

    setState(() {
      imageUpdate = file;
    });
  }

  pickImageGallery() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    io.File file = io.File(img!.path);

    setState(() {
      imageUpdate = file;
    });
  }

  Future<io.File> saveImage(io.File file) async {
    print('saveimage');
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
  void initState() {
    // TODO: implement initState
    image = widget.image;
    nameController.text = widget.productname;
    quantityController.text = widget.quantity;
    priceController.text = widget.price;
    imageUpdate = File('${imagePath + widget.productname}.png');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Map productsHistory =
                    await localdb.get('productsDetails') ?? {};
                print(productsHistory);
                productsHistory.remove(widget.productname);
                await localdb.put('productsDetails', productsHistory);
                Navigator.pushNamedAndRemoveUntil(context, '/', (c) => false);
              },
              icon: Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: bodyContent(context),
    );
  }

  SingleChildScrollView bodyContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textfields(context),
            const SizedBox(height: 15),
            _errorCard(),
            const Divider(),
            isLoading != false
                ? image != null && image != false
                    ? _imageCard()
                    : Text(err)
                : const CircularProgressIndicator(),
            _imageSelection(),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
            _doneButton(),
          ],
        ),
      ),
    );
  }

  SizedBox _doneButton() {
    return SizedBox(
      height: 45,
      width: 90,
      child: ElevatedButton(
        onPressed: () async {
          check();
        },
        child: isLoading != true
            ? const Text('Done')
            : const CircularProgressIndicator(),
      ),
    );
  }

  SizedBox _imageCard() {
    return SizedBox(
        height: 150,
        width: double.infinity,
        child: Card(
            elevation: 20,
            child: Image.file(
              File('${imagePath + widget.productname}.png'),
              fit: BoxFit.fill,
            )));
  }

  Card _errorCard() {
    return Card(
      child: Text(err),
    );
  }

  Card _imageSelection() {
    return Card(
      elevation: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 45,
                width: 113,
                child: OutlinedButton(
                  onPressed: () {
                    pickImageCamera();
                  },
                  child: Text(
                    'Camera',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
              SizedBox(
                height: 45,
                width: 113,
                child: OutlinedButton(
                  onPressed: () {
                    pickImageGallery();
                  },
                  child: Text(
                    'Gallery',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  Card _textfields(BuildContext context) {
    return Card(
      elevation: 15,
      child: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(
              'Update Correct Details',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(
              height: 25,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: ' Name',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: ScreenSize(context, false, 33),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: ' Price',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 27,
                ),
                SizedBox(
                  width: ScreenSize(context, false, 33),
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: ' Quantity',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
