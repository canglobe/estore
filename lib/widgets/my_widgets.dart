import 'package:flutter/material.dart';

Widget myButton({onPressed, child}) {
  return SizedBox(
    height: 45,
    width: 130,
    child: ElevatedButton(
      onPressed: onPressed,
      child: child,
    ),
  );
}

Widget myText({size, text}) {
  return Text(
    text,
    style: TextStyle(fontSize: size),
  );
}
