import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

pickImageCamera() async {
  // String name = nameController.text.toString();
  // io.Directory? temp = await getExternalStorageDirectory();
  // var path1 = temp!.path;
  // XFile? img = await ImagePicker().pickImage(
  //   source: ImageSource.camera,
  //   imageQuality: 50,
  // );
  // io.File img1 = io.File(img!.path);
  // io.File newImage = await io.File(img1.path).copy('$path1/images/$name.jpg');
  // setState(() {
  //   image = newImage;
  // });
  XFile? img = await ImagePicker().pickImage(source: ImageSource.camera);
  io.File img1 = io.File(img!.path);
  return img1;
}

pickImageGallery() async {
  XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
  io.File img1 = io.File(img!.path);
  return img1;
}
