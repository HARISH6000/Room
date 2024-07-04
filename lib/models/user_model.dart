import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uname;
  final bool isAdmin;
  final bool isAnon;
  final Timestamp ts;
  const User({
    required this.uname,
    required this.isAdmin,
    required this.isAnon,
    required this.ts,
  });
  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      uname: data?['uname'],
      isAdmin: data?['isAdmin'],
      isAnon: data?['isAnon'],
      ts: data?['ts'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "uname": uname,
      "isAdmin": isAdmin,
      "isAnon": isAnon,
      "ts": ts,
    };
  }
}
