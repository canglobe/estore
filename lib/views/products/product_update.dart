import 'dart:io' as io;
import 'package:image/image.dart' as im;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:estore/main.dart';
import 'package:estore/constants/constants.dart';

class ProductUpdate extends StatefulWidget {
  final bool image;
  final String price;
  final String quantity;
  final String productname;

  const ProductUpdate(
      {super.key,
      required this.productname,
      required this.price,
      required this.quantity,
      required this.image});

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  io.File? updatedImage;
  bool? isLoading;
  bool image = false;

  String err = '';

  preCheck() {
    String name = nameController.text.toString();
    String price = priceController.text.toString();
    String qty = quantityController.text.toString();
    name.isNotEmpty &&
            qty.isNotEmpty &&
            price.isNotEmpty &&
            updatedImage != null
        ? proceedData(name, qty, price)
        : throwError();
  }

  void proceedData(String name, String qty, String price) async {
    setState(() {
      isLoading = true;
    });

    bool haveImage = image != null ? true : false;
    haveImage != false ? saveImage(io.File(updatedImage!.path)) : () {};
    Map productDetails = await localdb.get('productDetails') ?? {};
    List productNames = await localdb.get('productNames') ?? [];

    productDetails[name] = {
      'image': haveImage,
      'price': price,
      'quantity': qty,
    };

    productNames.add(name);

    await localdb.put('productDetails', productDetails);
    await localdb.put('productNames', productNames);

    //await ref.child('productNames').set(productNames);
    //await ref.child('productDetails').set(productDetails);

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
      updatedImage = file;
    });
  }

  pickImageGallery() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    io.File file = io.File(img!.path);

    setState(() {
      updatedImage = file;
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
  void initState() {
    image = widget.image;
    nameController.text = widget.productname;
    quantityController.text = widget.quantity;
    priceController.text = widget.price;
    updatedImage =
        image ? io.File('${imagePath + widget.productname}.png') : null;

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
                Map productHistory = await localdb.get('productDetails') ?? {};

                productHistory.remove(widget.productname);
                await localdb.put('productDetails', productHistory);

                Navigator.pushNamedAndRemoveUntil(context, '/', (c) => false);
              },
              icon: const Icon(Icons.delete_forever_outlined))
        ],
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
        image != false
            ? _imageCard()
            : Text(
                'Select Image',
                style: Theme.of(context).textTheme.displayLarge,
              ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  io.File(updatedImage!.path),
                  fit: BoxFit.fill,
                ))),
      ],
    );
  }

  _doneButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 45,
          width: 90,
          child: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent, fontSize: 18),
              )),
        ),
        SizedBox(
          height: 45,
          width: 90,
          child: ElevatedButton(
            onPressed: () async {
              preCheck();
            },
            child: isLoading != true
                ? Center(
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
          ),
        ),
      ],
    );
  }
}
