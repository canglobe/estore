import 'package:flutter/material.dart';

String imagePath =
    "/storage/emulated/0/Android/data/com.quantec.estore/files/images/";

// Main Colors
const primaryColor = Color.fromARGB(255, 0, 189, 213);
const secondryColor = Color.fromARGB(255, 33, 150, 243);
const bgColor = Color.fromARGB(255, 239, 250, 252);
const scaffoldBgColor = Color.fromARGB(255, 243, 249, 250);
const cardBgColor = Color.fromRGBO(250, 253, 254, 1);
const txtColor = Color.fromARGB(255, 33, 33, 33);
const whitecolor = Colors.white;
const primaryBgColor = Color.fromARGB(255, 93, 200, 214);

// Text Colors Light Theme
const textLightColor = Color.fromARGB(255, 55, 55, 55);
const subTextColor = Color.fromARGB(255, 77, 77, 77);
const miniTextColor = Color.fromARGB(255, 99, 99, 99);
const primaryTextColor = Color.fromARGB(255, 0, 149, 173);

// Text Colors Dark Theme
const textDarkColor = Color.fromARGB(255, 247, 245, 245);

// Additional Color Pallete
const greenColor = Color(0xff8ad979);
const skyblueColor = Color(0xff5bcfc9);
const orangeColor = Color(0xfffa9f43);

customTime() {
  DateTime now = DateTime.now().add(const Duration(days: 0));
  return '${now.year}-${now.month}-${now.day} ${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute}:${now.second}';
}

TextStyle mystyle(double size,
    {bool bold = false, Color color = Colors.black}) {
  return TextStyle(
      fontSize: size,
      fontWeight: bold != true ? FontWeight.normal : FontWeight.bold,
      color: color);
}
