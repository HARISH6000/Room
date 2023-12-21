import 'package:flutter/material.dart';
import 'package:room/pages/instruction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room/pages/room.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String roomno = '', temp = '';
  final _txt_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Valorax',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                temp = "pressed +";
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Instruction()));
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 200,
                child: TextField(
                  onTapOutside: (PointerDownEvent e) {
                    FocusScope.of(context).unfocus();
                  },
                  onSubmitted: (str) {
                    setState(() {
                      isLoading = true;
                      if (str != '') {
                        temp = 'Entered room number:';
                      } else {
                        temp = '';
                      }
                      roomno = str;
                    });
                    db
                        .collection("Room")
                        .where("rid", isEqualTo: str)
                        .get()
                        .then((querySnapshot) {
                      print("query successful");
                      print(querySnapshot.docs);
                      if (querySnapshot.docs.isEmpty) {
                        setState(() {
                          roomno += ".\nThis room does not exist.";
                          isLoading = false;
                        });
                      } else {
                        var data = querySnapshot.docs.first;
                        setState(() {
                          isLoading = false;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoomPage(
                                        rid: str,
                                        rname: data["rname"],
                                        desc: data["desc"],
                                      )));
                        });
                      }
                    }, onError: (e) {
                      print("error: $e");
                    });
                  },
                  controller: _txt_controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Radiotechnika',
                    color: Colors.white,
                  ),
                  cursorColor: const Color.fromARGB(159, 104, 58, 183),
                  decoration: InputDecoration(
                    isCollapsed: false,
                    isDense: false,
                    fillColor: Colors.black,
                    filled: true,
                    hintStyle: const TextStyle(color: Colors.white54),
                    hintText: 'Room',
                    border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(100)),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 104, 58, 183), width: 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 244, 67, 54), width: 1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    enabled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.deepPurple,
                      )
                    : Container(
                        child: Text(
                          temp + roomno,
                          style: const TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
