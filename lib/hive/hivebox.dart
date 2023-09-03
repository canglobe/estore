import 'package:estore/main.dart';

class HiveBox {
  ldbGet() async {
    var ldb = await localdb.get('ldb') ?? {};

    return ldb;
  }

  ldbPut(onlineldb) async {
    await localdb.put('ldb', onlineldb);
  }

  ldbccGet() async {
    Map ldbcc = await localdb.get('ldbcc') ?? {};
    return ldbcc;
  }

  ldbccPut(onlinedb) async {
    await localdb.put('ldbcc', onlinedb);
  }

  updateImage() {}
}
