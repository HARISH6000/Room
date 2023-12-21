import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String? rid;
  final String? rname;
  final String? desc;

  const Room({
    this.rid,
    this.rname,
    this.desc,
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
      if (rid != null) "rid": rid,
      if (rname != null) "rname": rname,
      "desc": desc,
    };
  }
}
