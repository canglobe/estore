import 'package:firebase_database/firebase_database.dart';

class FB {
  ref(referance) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(referance);
    return ref;
  }
}
