import 'package:estore/constants.dart';
import 'package:estore/hive/hiveinit.dart';
import 'package:estore/main.dart';
import 'package:estore/model/productsmodel.dart';

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

  io.File? image;
  bool? isLoading;

  String err = '';

  check() {
    String name = nameController.text.toString();
    String price = priceController.text.toString();
    String qty = quantityController.text.toString();
    name.isNotEmpty && qty.isNotEmpty && price.isNotEmpty && image != null
        ? proceedData(name, qty, price, image!)
        : throwError();
  }

  proceedData(String name, String qty, String price, io.File image) async {
    setState(() {
      isLoading = true;
    });

    Map ldb = await HiveBox().ldb();
    var imagedir = await saveImage(image);

    var pr = Products(
      name: name,
      price: price,
      imagedir: imagedir.path.toString(),
      quantity: qty,
    ).toMap();

    ldb[name] = pr[name];

    await localdb.put('ldb', ldb);

    setState(() {
      isLoading = false;
    });
    navigate();
  }

  navigate() {
    Navigator.pop(context);
  }

  throwError() {
    err = 'Please Check necessary fields';
    setState(() {});
  }

  show() {
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: CircularProgressIndicator(),
          );
        });
  }

  pickImageCamera() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    io.File file = io.File(img!.path);

    setState(() {
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
      print(e);
      return io.File('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Plus',
          style: mystyle(24, bold: true),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(23),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Enter Correct Details',
                        style: mystyle(24, bold: true),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Name',
                            style: mystyle(20, bold: false),
                          ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Price',
                            style: mystyle(20, bold: false),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: ' Price',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Quantity',
                            style: mystyle(20, bold: false),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: ' Quantity',
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
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              isLoading != true
                  ? image != null
                      ? SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: Card(
                              elevation: 20,
                              child: Image.file(
                                io.File(image!.path),
                                fit: BoxFit.fill,
                              )))
                      : Text(err)
                  : const CircularProgressIndicator(),
              Card(
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
                            child: const Text('Camera'),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 113,
                          child: OutlinedButton(
                            onPressed: () {
                              pickImageGallery();
                            },
                            child: const Text('Gallery'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Divider(),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
