import 'package:estore/main.dart';

// Object for hive database
HiveDB hiveDb = HiveDB();

class HiveDB {
  // Theme mode
  Future<bool> getThemeMode() async => await localdb.get('darkMode') ?? false;

  putThemeMode(data) async => await localdb.put('darkMode', data);

  // Products
  getProductNames() async => await localdb.get('productNames') ?? [];

  putProductNames(data) async => await localdb.put('productNames', data);

  getProductHistory() async => await localdb.get('productHistory') ?? {};

  putProductHistory(data) async => await localdb.put('productHistory', data);

  getProductDetails() async => await localdb.get('productDetails') ?? {};

  putProductDetails(data) async => await localdb.put('productDetails', data);

  // customers
  getPersonsHistory() async => await localdb.get('customersHistory') ?? {};

  putPersonsHistory(data) async => await localdb.put('customersHistory', data);

  getPersonsNames() async => await localdb.get('customers') ?? [];

  putPersonsNames(data) async => await localdb.put('customers', data);

  // Overall history
  getOverallHistory() async => await localdb.get('overallHistory') ?? {};

  putOverallHistory(data) async => await localdb.put('overallHistory', data);
}
