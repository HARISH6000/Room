import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String rid;
  final String rname;
  final String desc;

  const Room({
    required this.rid,
    required this.rname,
    required this.desc,
  });

  factory Room.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Room(
      rid: data?['rid'],
      rname: data?['rname'],
      desc: data?['desc'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "rid": rid,
      "rname": rname,
      "desc": desc,
    };
  }
}
