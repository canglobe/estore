import 'package:firebase_database/firebase_database.dart';

FB fb = FB();

class FB {
  DatabaseReference ref() {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    return ref;
  }
}
