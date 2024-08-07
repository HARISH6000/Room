import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String msg;
  final Timestamp ts;
  final String uid;
  final String id;
  const Message({
    required this.msg,
    required this.ts,
    required this.uid,
    required this.id,
  });

  factory Message.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Message(
      msg: data?['msg'],
      ts: data?['ts'],
      uid: data?['uid'],
      id: data?['id'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "msg": msg,
      "ts": ts,
      "uid": uid,
      "id": id,
    };
  }
}
