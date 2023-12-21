import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room/models/room_model.dart';
import 'package:room/models/message_model.dart';

class FirebaseFirestoreServices {
  final String rid;
  const FirebaseFirestoreServices({required this.rid});
  Future<void> addMsg(String msg, String uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final message = Message(msg: msg, ts: Timestamp.now(), uid: uid);
    await db
        .collection("Room")
        .doc(rid)
        .collection("Message")
        .doc()
        .set(message.toFirestore());
  }
}
