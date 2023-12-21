import 'package:flutter/material.dart';

screenSize(context, {required bool isHeight, required double percentage}) {
  var size = isHeight != false
      ? MediaQuery.of(context).size.height / 100
      : MediaQuery.of(context).size.width / 100;

  return size * percentage;
}
