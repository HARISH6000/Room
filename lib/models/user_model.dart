import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uname;
  const User({
    required this.uname,
  });
  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      uname: data?['uname'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "uname": uname,
    };
  }
}
