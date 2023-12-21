import 'package:estore/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:estore/hive/hivebox.dart';
import 'package:estore/widgets/my_widgets.dart';
import 'package:estore/constants/constants.dart';
import 'package:image/image.dart' as im;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

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

  bool? image;
  bool? isLoading;
  String err = '';
  io.File? updatedImage;

  void pickImageCamera() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    io.File file = io.File(img!.path);

    setState(() {
      updatedImage = file;
      image = true;
    });
  }

  void pickImageGallery() async {
    XFile? img = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    io.File file = io.File(img!.path);

    setState(() {
      updatedImage = file;
      image = true;
    });
  }

  Future<io.File> saveImage(io.File file) async {
    String name = nameController.text.toString();
    try {
      var dir = await getExternalStorageDirectory();
      var imagedir =
          await io.Directory('${dir!.path}/images').create(recursive: true);

      im.Image? image = im.decodeImage(file.readAsBytesSync());
      return io.File('${imagedir.path}/$name.jpg')
        ..writeAsBytesSync(im.encodePng(image!));
    } catch (e) {
      return io.File('');
    }
  }

  void preCheck() {
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

    bool haveImage = updatedImage != null ? true : false;
    haveImage != false ? saveImage(io.File(updatedImage!.path)) : () {};
    Map productDetails = await hiveDb.getProductDetails();
    List productNames = await hiveDb.getProductNames();

    productDetails[name] = {
      'image': haveImage,
      'price': price,
      'quantity': qty,
    };

    productNames.add(name);

    await hiveDb.putProductDetails(productDetails);
    await hiveDb.putProductNames(productNames);

    setState(() {
      isLoading = false;
    });
    navigationToPop();
    navigationToPop();
  }

  void throwError() {
    err = 'Please Check necessary fields';
    setState(() {});
  }

  @override
  void initState() {
    image = widget.image;
    nameController.text = widget.productname;
    quantityController.text = widget.quantity;
    priceController.text = widget.price;
    updatedImage =
        image! ? io.File('${imagePath + widget.productname}.jpg') : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        title: Text(
          'Update Product Details',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm"),
                      content: const Text(
                          "Are you sure you wish to delete this product?"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () async {
                              Map productDetails =
                                  await hiveDb.getProductDetails();

                              productDetails.remove(widget.productname);
                              await hiveDb.putProductDetails(productDetails);

                              navigationToSplash();
                            },
                            child: const Text(
                              "DELETE",
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            )),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("CANCEL"),
                        ),
                      ],
                    );
                  },
                );
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
                      style: Theme.of(context).textTheme.titleSmall,
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
          'Update',
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
        const SizedBox(height: 12),
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
        io.File('${imagePath + widget.productname}.jpg').existsSync() ||
                updatedImage != null
            ? _alreadyHaveImage()
            : Text(
                'Select Image',
                style: Theme.of(context).textTheme.titleLarge,
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
                  style: Theme.of(context).textTheme.titleSmall,
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
                Text('Gallery', style: Theme.of(context).textTheme.titleSmall),
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

  _alreadyHaveImage() {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          'Selected Image',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Stack(
          children: [
            SizedBox(
                height: 150,
                width: 300,
                child: Card(
                    elevation: 20,
                    child: Image.file(
                      io.File(updatedImage!.path),
                      fit: BoxFit.fill,
                    ))),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  padding: const EdgeInsets.all(9),
                  splashRadius: 25,
                  onPressed: () async {
                    if (io.File('${imagePath + widget.productname}.jpg')
                        .existsSync()) {
                      io.File('${imagePath + widget.productname}.jpg').delete();
                      Map productDetails = await hiveDb.getProductDetails();
                      productDetails[widget.productname]['image'] = false;
                      await hiveDb.putProductDetails(productDetails);
                    }
                    setState(() {
                      image = false;
                      updatedImage = null;
                    });
                  },
                  icon: const Card(
                    child: Icon(
                      Icons.close,
                      color: Colors.redAccent,
                    ),
                  )),
            ),
          ],
        ),
      ],
    );
  }

  _doneButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        myButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Back',
            )),
        const SizedBox(
          width: 5,
        ),
        myButton(
          onPressed: () async {
            preCheck();
          },
          child: isLoading != true
              ? const Center(
                  child: Text(
                    'Update',
                  ),
                )
              : const CircularProgressIndicator(
                  color: Colors.white,
                ),
        ),
      ],
    );
  }

  void navigationToPop() {
    Navigator.pop(context, true);
  }

  void navigationToSplash() {
    Navigator.pushNamedAndRemoveUntil(context, '/', (context) => false);
  }
}
