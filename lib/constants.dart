import 'package:flutter/material.dart';

String imagePath =
    "/storage/emulated/0/Android/data/com.quantec.estore/files/images/";

const List imgurl = [
  'https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg?w=2000',
  'https://img.freepik.com/free-photo/green-field-tree-blue-skygreat-as-backgroundweb-banner-generative-ai_1258-158251.jpg?w=2000',
  'https://img.freepik.com/premium-photo/suspension-bridge-travel-nature-scenery-building_1417-264.jpg?w=2000',
  'https://img.freepik.com/free-vector/copy-space-bokeh-spring-lights-background_52683-55649.jpg?w=2000',
  'https://img.freepik.com/premium-vector/river-forest-mountains-sunrise-vector-landscape-beautiful-nature-hills-trees-morning_500415-28.jpg?w=2000'
];
Map data = {};

List<String> prnames = <String>[
  'product 1',
  'product 2',
  'product 3',
  'product 4',
  'product 5',
];

List<String> cunames = <String>[
  '',
  'person 1',
  'person 2',
  'person 3',
  'person 4',
  'person 5',
];

TextStyle mystyle(double size,
    {bool bold = false, Color color = Colors.black}) {
  return TextStyle(
      fontSize: size,
      fontWeight: bold != true ? FontWeight.normal : FontWeight.bold,
      color: color);
}

Color primaryColor = Color.fromARGB(255, 224, 190, 125);
Color secondryColor = Color.fromARGB(255, 10, 36, 42);
Color greenColor = const Color(0xff8ad979);
Color skyblueColor = const Color(0xff5bcfc9);
Color orangeColor = const Color(0xfffa9f43);
