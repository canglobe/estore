import 'package:estore/main.dart';

class HiveDB {
  getProductNames() async {
    List data = await localdb.get('productNames') ?? [];

    return data;
  }

  putProductNames(data) async {
    await localdb.put('productNames', data);
  }

  getProductHistory() async {
    Map data = await localdb.get('productHistory') ?? {};
    return data;
  }

  putProductHistory(data) async {
    await localdb.put('productHistory', data);
  }

  getProductDetails() async {
    Map data = await localdb.get('productDetails') ?? {};
    return data;
  }

  putProductDetails(data) async {
    await localdb.put('productDetails', data);
  }

// ----------------------------------------------------person
  getPersonsHistory() async {
    Map data = await localdb.get('personsHistory') ?? {};
    return data;
  }

  putPersonsHistory(data) async {
    await localdb.put('personsHistory', data);
  }

  getPersonsNames() async {
    List data = await localdb.get('personsNames') ?? [];

    return data;
  }

// ------------------------------------------------------
}
