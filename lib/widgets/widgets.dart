import 'package:flutter/material.dart';

Widget myButton({onPressed, child}) {
  return SizedBox(
    height: 45,
    width: 90,
    child: ElevatedButton(
      onPressed: onPressed,
      child: child,
    ),
  );
}

myText({size, text}) {
  return Text(
    text,
    style: TextStyle(fontSize: size),
  );
}
