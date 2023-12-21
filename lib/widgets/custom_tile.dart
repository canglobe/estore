import 'package:flutter/material.dart';
import 'package:estore/utils/screen_size.dart';
import 'package:estore/constants/constants.dart';

Widget customTile(
  context, {
  required String date,
  required String name,
  required String price,
  required String quantity,
}) {
  return SizedBox(
    height: screenSize(context, isHeight: true, percentage: 14),
    width: screenSize(context, isHeight: true, percentage: 97),
    child: Card(
      elevation: 0.3,
      color: cardBgColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 9, right: 9, top: 3, bottom: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    // color: Color.fromARGB(255, 0, 149, 173),
                    color: secondryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  'Sold Count: $quantity',
                  style: const TextStyle(
                    // color: Color.fromARGB(255, 0, 149, 173),
                    color: secondryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                name,
                style: const TextStyle(
                  color: textLightColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 16,
                      color: Colors.black54,
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ),
  );
}
