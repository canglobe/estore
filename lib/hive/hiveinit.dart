import 'package:estore/main.dart';

class HiveBox {
  ldb() async {
    var ldb = await localdb.get('ldb') ?? {};
    return ldb;
  }

  ldbcc() async {
    var ldbcc = await localdb.get('ldbcc') ?? {};
    return ldbcc;
  }

  updateImage() {}
}
