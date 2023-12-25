import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:room/models/message_model.dart';
import 'package:room/pages/roominfo.dart';
import 'package:room/services/firestore_services.dart';

class RoomPage extends StatefulWidget {
  final dynamic rid;
  final dynamic rname;
  final dynamic desc;
  const RoomPage(
      {super.key, String? this.rid, String? this.rname, String? this.desc});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String uid = "user" + Random().nextInt(1000).toString();
  bool isLoading = false;
  TextEditingController tf = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FirebaseFirestoreServices fs = FirebaseFirestoreServices(rid: widget.rid);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.rname + "-" + widget.rid,
          style: const TextStyle(
            color: Colors.white54,
            fontFamily: "Radiotechnika",
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomInfoPage(
                        rid: widget.rid,
                        rname: widget.rname,
                        desc: widget.desc,
                      ),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.info_outline))
        ],
        shadowColor: const Color.fromARGB(41, 255, 255, 255),
        backgroundColor: Colors.black,
        elevation: 2.0,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Room")
                  .doc(widget.rid)
                  .collection("Message")
                  .orderBy("ts", descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    width: 100,
                    height: 100,
                    child: Text(
                      "Loading...",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  );
                } else if (snapshot.data.docs.isEmpty) {
                  return const SizedBox(
                    width: 100,
                    height: 100,
                    child: Text(
                      "Nothing here",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  );
                } else {
                  return Flexible(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 1.0,
                      child: ListView.builder(
                        dragStartBehavior: DragStartBehavior.down,
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          return ListTile(
                            title: Text(
                              ds["uid"] + ": " + ds["msg"],
                              style: const TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              }),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            child: TextField(
              autocorrect: false,
              controller: tf,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: 'SpecialGothic',
              ),
              onSubmitted: (value) async {
                if (tf.text.isNotEmpty) {
                  setState(() {
                    isLoading = true;
                  });
                  tf.clear();
                  if (value.startsWith("userName:")) {
                    uid = value.substring(9);
                  } else {
                    await fs.addMsg(value, uid);
                  }
                  //await Future.delayed(Duration(seconds: 3));
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              onTapOutside: (PointerDownEvent pde) async {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.send_outlined,
                          semanticLabel: "Send",
                        ),
                  onPressed: () async {
                    if (tf.text.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      String msg = tf.text;
                      tf.clear();
                      if (msg.startsWith("userName:")) {
                        uid = msg.substring(9);
                      } else {
                        await fs.addMsg(msg, uid);
                      }
                      //await Future.delayed(Duration(seconds: 3));
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.white54,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
