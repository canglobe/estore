import 'dart:io' as io;

import 'package:image/image.dart' as im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<io.File> saveImage(io.File file, String productName) async {
  try {
    var dir = await getExternalStorageDirectory();
    var imagedir =
        await io.Directory('${dir!.path}/images').create(recursive: true);

    im.Image? image = im.decodeImage(file.readAsBytesSync());
    return io.File('${imagedir.path}/$productName.jpg')
      ..writeAsBytesSync(im.encodePng(image!));
  } catch (e) {
    return io.File('');
  }
}

Future<io.File> pickImageCamera() async {
  XFile? img = await ImagePicker().pickImage(
    source: ImageSource.camera,
    imageQuality: 25,
  );

  io.File file = io.File(img!.path);

  return file;
}

Future<io.File> pickImageGallery() async {
  XFile? img = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 25,
  );
  io.File file = io.File(img!.path);

  return file;
}
