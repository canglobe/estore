// import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_database/firebase_database.dart';

class Fb {
  mydb() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

    await ref.set({
      "name": "John",
      "age": 18,
      "address": {"line1": "100 Mountain View"}
    });
  }
}