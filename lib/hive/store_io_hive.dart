import 'dart:io' as io;

import '../constants/constants.dart';
import '../model/overall_history_model.dart';
import '../model/products_model.dart';
import '../utils/image_io.dart';
import 'hivebox.dart';

HiveIO hiveIO = HiveIO();

class HiveIO {
  storeNewProduct({
    required String productName,
    required String price,
    required String quantity,
    io.File? image,
    required bool haveImage,
  }) async {
    List productNames = [];
    productNames = await hiveDb.getProductNames() ?? [];
    productNames.contains(productName) ? () {} : productNames.add(productName);

    Map productDetails = await hiveDb.getProductDetails() ?? {};
    if (!productDetails.containsKey(productName)) {
      productDetails.putIfAbsent(
          productName,
          () => ProductsModel(
                  name: productName,
                  price: price,
                  image: haveImage,
                  quantity: quantity)
              .toMap());

      haveImage != false ? saveImage(io.File(image!.path), productName) : () {};

      await hiveDb.putProductDetails(productDetails);
      await hiveDb.putProductNames(productNames);
      return true;
    } else {
      return false;
    }
  }

  storeSoldData(
    String customerName,
    String productName,
    String soldPrice,
    String soldQuantity,
  ) async {
    // Date
    String date = customTime();
    String dateOnly =
        '${date.substring(0, 4)}-${date.substring(5, 7)}-${date.substring(8, 10)}';

    Map productDetails = await hiveDb.getProductDetails();
    Map productHistory = await hiveDb.getProductHistory();

    List customers = await hiveDb.getPersonsNames();
    Map personsHistory = await hiveDb.getPersonsHistory();

    if (!customers.contains(customerName)) {
      customers.add(customerName);
      await hiveDb.putPersonsNames(customers);
    } else {}

    if (!productHistory.containsKey(productName)) {
      productHistory[productName] = {};
      productHistory[productName][date] = {
        'customer': customerName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };
      await hiveDb.putProductHistory(productHistory);
    } else {
      productHistory[productName][date] = {
        'customer': customerName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };

      await hiveDb.putProductHistory(productHistory);
    }

    if (!personsHistory.containsKey(customerName)) {
      personsHistory[customerName] = {};
      personsHistory[customerName][date] = {
        'product': productName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };
      await hiveDb.putPersonsHistory(personsHistory);
    } else {
      personsHistory[customerName][date] = {
        'product': productName,
        'quantity': soldQuantity,
        'price': soldPrice,
      };
      await hiveDb.putPersonsHistory(personsHistory);
    }

    var quantity = productDetails[productName]['quantity'];
    int qty = int.parse(quantity) - int.parse(soldQuantity);
    productDetails[productName]['quantity'] = qty.toString();
    await hiveDb.putProductDetails(productDetails);

    Map overallHistory = await hiveDb.getOverallHistory();

    if (!overallHistory.containsKey(dateOnly)) {
      overallHistory[dateOnly] = {};
      overallHistory[dateOnly].putIfAbsent(
        date,
        () => OverallHistoryModel(
                customer: customerName,
                product: productName,
                price: soldPrice,
                quantity: soldQuantity,
                soldDate: date)
            .toMap(),
      );
      await hiveDb.putOverallHistory(overallHistory);
    } else {
      overallHistory[dateOnly].putIfAbsent(
        date,
        () => OverallHistoryModel(
          customer: customerName,
          product: productName,
          price: soldPrice,
          quantity: soldQuantity,
          soldDate: date,
        ).toMap(),
      );
      await hiveDb.putOverallHistory(overallHistory);
    }

    return 1;
  }

  deleteSoldData(String productName, String indexDelete) async {
    Map productHistory = await hiveDb.getProductHistory();
    var personsHistory = await hiveDb.getPersonsHistory();
    var productdetails = await hiveDb.getProductDetails();
    Map overAllHistory = await hiveDb.getOverallHistory();

    Map history = productHistory[productName];
    var customer = history[indexDelete]['customer'];
    var quant = history[indexDelete]['quantity'];

    var qty = productdetails[productName]['quantity'];

    var newqty = int.parse(qty) + int.parse(quant);
    productdetails[productName]['quantity'] = newqty.toString();

    Map history1 = personsHistory[customer];
    history1.remove(indexDelete);
    history.remove(indexDelete);
    personsHistory[customer] = history1;
    productHistory[productName] = history;

    var dateOnly = indexDelete.substring(0, 10);
    Map history3 = overAllHistory[dateOnly];
    history3.remove(indexDelete);
    overAllHistory[dateOnly] = history3;
    await hiveDb.putPersonsHistory(productHistory);
    await hiveDb.putPersonsHistory(personsHistory);
    await hiveDb.putProductDetails(productdetails);
    await hiveDb.putOverallHistory(overAllHistory);

    return 1;
  }
}
