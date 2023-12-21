import 'package:estore/hive/hivebox.dart';
import 'package:estore/hive/store_io_hive.dart';

import 'package:estore/utils/screen_size.dart';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import '../../utils/image_io.dart';

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

  io.File? image;
  bool? isLoading;

  String err = '';

  preCheck() async {
    String productName = nameController.text;
    String productPrice = priceController.text;
    String productQuantity = quantityController.text;

    if (productName.isNotEmpty &&
        productPrice.isNotEmpty &&
        productQuantity.isNotEmpty) {
      var done = await hiveIO.storeNewProduct(
        productName: productName,
        price: productPrice,
        quantity: productQuantity,
        image: image,
        haveImage: image != null ? true : false,
      );
      return done;
    } else {
      _throwError();
    }
  }

  _throwError() {
    err = 'Please check necessary fields.';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(
          'New Product',
          style: Theme.of(context).textTheme.displayMedium,
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
                      style: Theme.of(context).textTheme.titleSmall!.apply(
                            color: Colors.redAccent,
                          ),
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
        Text('Product Details', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        SizedBox(
          height: screenSize(context, isHeight: true, percentage: 9),
          child: TextField(
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
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: screenSize(context, isHeight: true, percentage: 9),
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
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: screenSize(context, isHeight: true, percentage: 9),
          child: TextField(
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
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
            ? _selectedImage()
            : Text(
                'Select Image',
                style: Theme.of(context).textTheme.titleLarge,
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
                      onPressed: () async {
                        var img = await pickImageCamera();
                        setState(() {
                          image = img;
                        });
                      },
                      child: const Icon(Icons.camera_alt)),
                ),
                Text(
                  'Camera',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 45,
                  width: 113,
                  child: OutlinedButton(
                      onPressed: () async {
                        var img = await pickImageGallery();
                        setState(() {
                          image = img;
                        });
                      },
                      child: const Icon(Icons.photo)),
                ),
                Text(
                  'Gallery',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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

  _selectedImage() {
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
          bool done = await preCheck();
          done
              ? navToPop()
              : setState(() {
                  err = 'Already exists this product';
                  isLoading = false;
                });
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

  navToPop() {
    Navigator.pop(context);
  }
}
