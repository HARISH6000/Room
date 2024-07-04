import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:room/models/message_model.dart';
import 'package:room/models/user_model.dart';
import 'package:room/pages/roominfo.dart';
import 'package:room/services/firestore_services.dart';

class RoomPage extends StatefulWidget {
  final dynamic rid;
  final dynamic rname;
  final dynamic desc;
  final dynamic us;
  const RoomPage(
      {super.key,
      String? this.rid,
      String? this.rname,
      String? this.desc,
      DocumentSnapshot? this.us});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  //String uid =  "user" + Random().nextInt(1000).toString();
  bool isLoading = false;
  TextEditingController tf = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    String uid = widget.us['uname'];
    String id = widget.us.id;
    FirebaseFirestoreServices fs = FirebaseFirestoreServices(rid: widget.rid);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: colorScheme.secondary.withOpacity(0.1)),
        centerTitle: true,
        title: Text(
          widget.rname + "-" + widget.rid,
          style: TextStyle(
            color: colorScheme.secondary,
            fontFamily: "Radiotechnika",
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
              icon: Icon(
                Icons.info_outline,
                color: colorScheme.secondary.withOpacity(0.2),
              ))
        ],
        //shadowColor: colorScheme.primary.withOpacity(0.1), //const Color.fromARGB(41, 255, 255, 255),
        backgroundColor: Colors.black,
        elevation: 2.0,
      ),
      backgroundColor: colorScheme.background,
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
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Text(
                      "Nothing here",
                      style: TextStyle(
                        color: colorScheme.secondary,
                      ),
                    ),
                  );
                } else {
                  return Flexible(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 1.0,
                      child: ListView.builder(
                        dragStartBehavior: DragStartBehavior.down,
                        reverse: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot ds = snapshot.data.docs[index];
                          Map<String, dynamic> data =
                              ds.data() as Map<String, dynamic>;
                          return Align(
                            alignment: data.containsKey('id') && id == ds["id"]
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Card(
                              elevation: 0.2,
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.005,
                              ),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: colorScheme.primary,
                                    width: 0.5,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              color: colorScheme.primary.withAlpha(31),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  10.0,
                                  6.0,
                                  20.0,
                                  10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ds["uid"],
                                      style: TextStyle(
                                        color: colorScheme.primary,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      " " *
                                              (ds["uid"].length < 3
                                                  ? ds["uid"].length
                                                  : 3) +
                                          ds["msg"],
                                      style: TextStyle(
                                        color: colorScheme.tertiary,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
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
            padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: TextField(
              autocorrect: false,
              controller: tf,
              style: TextStyle(
                color: colorScheme.secondary,
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
                    await fs.addMsg(
                      value,
                      uid,
                      id,
                    );
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
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
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
                        await fs.addMsg(
                          msg,
                          widget.us['uname'],
                          id,
                        );
                      }
                      //await Future.delayed(Duration(seconds: 3));
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.secondary,
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
