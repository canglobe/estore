// import 'dart:convert';
// import 'package:estore/main.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'dart:io' as io;

// class NewProduct extends StatefulWidget {
//   const NewProduct({super.key});

//   @override
//   State<NewProduct> createState() => _NewProductState();
// }

// class _NewProductState extends State<NewProduct> {
//   final nameController = TextEditingController();
//   final priceController = TextEditingController();
//   final quantityController = TextEditingController();

//   io.File? image;

//   String err = '';

//   check() {
//     String name = nameController.text.toString();
//     String price = priceController.text.toString();
//     String qty = quantityController.text.toString();
//     name.isNotEmpty && qty.isNotEmpty && price.isNotEmpty && image != null
//         ? proceedData(name, qty, price, image!)
//         : throwError();
//   }

//   proceedData(String name, String qty, String price, io.File image) async {
//     Map ldb = await localdb.get('ldb') ?? {};

//     final imgbytes = image.readAsBytesSync();
//     String img = base64Encode(imgbytes);

//     ldb[name] = {
//       'qty': qty,
//       'price': price,
//       'image': img,
//       'history': {},
//     };

//     await localdb.put('ldb', ldb);
//     navigate();
//   }

//   navigate() {
//     Navigator.pop(context);
//   }

//   throwError() {
//     err = 'Please Check necessary fields';
//     setState(() {});
//   }

//   pickImageCamera() async {
//     // String name = nameController.text.toString();
//     // io.Directory? temp = await getExternalStorageDirectory();
//     // var path1 = temp!.path;
//     // XFile? img = await ImagePicker().pickImage(
//     //   source: ImageSource.camera,
//     //   imageQuality: 50,
//     // );
//     // io.File img1 = io.File(img!.path);
//     // io.File newImage = await io.File(img1.path).copy('$path1/images/$name.jpg');
//     // setState(() {
//     //   image = newImage;
//     // });
//     XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
//     io.File img1 = io.File(img!.path);
//     setState(() {
//       image = img1;
//     });
//   }

//   pickImageGallery() async {
//     XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
//     io.File img1 = io.File(img!.path);
//     setState(() {
//       image = img1;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Add Product',
//           textScaleFactor: 1.1,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 'Hi',
//                 textScaleFactor: 1.5,
//               ),
//               const Divider(),
//               const SizedBox(
//                 height: 50,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
                  
//                   TextField(
//                     controller: nameController,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter Product Name',
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text('Enter Product Quantity'),
//                   TextField(
//                     controller: priceController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter Product Price',
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 25,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Text('Enter Product Quantity'),
//                   TextField(
//                     controller: quantityController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       labelText: 'Enter Product Quantity',
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(
//                 height: 50,
//               ),
//               const Divider(),
//               image != null
//                   ? SizedBox(
//                       height: 150,
//                       width: double.infinity,
//                       child: Image.file(io.File(image!.path)))
//                   : Text(err),
//               const SizedBox(
//                 height: 25,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   OutlinedButton(
//                     onPressed: () {
//                       pickImageCamera();
//                     },
//                     child: const Text('Camera'),
//                   ),
//                   OutlinedButton(
//                     onPressed: () {
//                       pickImageGallery();
//                     },
//                     child: const Text('Gallery'),
//                   ),
//                 ],
//               ),
             
//               const SizedBox(
//                 height: 50,
//               ),
//               ElevatedButton(
//                 onPressed: () async {
                  
//                   check();
//                 },
//                 child: const Text('Done'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
