import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room/models/room_model.dart';
import 'package:room/models/message_model.dart';
import 'package:room/models/user_model.dart';

class FirebaseFirestoreServices {
  String? rid = null;
  FirebaseFirestoreServices({this.rid});
  Future<void> addMsg(String msg, String uid, String id) async {
    if (rid == null) {
      return;
    }
    FirebaseFirestore db = FirebaseFirestore.instance;
    final message = Message(
      msg: msg,
      ts: Timestamp.now(),
      uid: uid,
      id: id,
    );
    await db
        .collection("Room")
        .doc(rid)
        .collection("Message")
        .doc()
        .set(message.toFirestore());
  }

  Future<void> addUsr(String? uid, String uname, bool isAnon) async {
    if (uid != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final user = User(
        uname: uname,
        isAdmin: false,
        isAnon: isAnon,
        ts: Timestamp.now(),
      );
      await db.collection("User").doc(uid).set(user.toFirestore());
    }
  }
}
