import 'package:estore/utils/pickimage.dart';
import 'package:flutter/material.dart';

Widget imageSelect() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OutlinedButton(
            onPressed: () {
              pickImageCamera();
            },
            child: const Text('Camera'),
          ),
          OutlinedButton(
            onPressed: () {
              pickImageGallery();
            },
            child: const Text('Gallery'),
          ),
        ],
      ),
      const SizedBox(
        height: 50,
      ),
    ],
  );
}
