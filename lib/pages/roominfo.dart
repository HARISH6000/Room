import 'package:flutter/material.dart';

class RoomInfoPage extends StatefulWidget {
  final dynamic rid;
  final dynamic rname;
  final dynamic desc;
  const RoomInfoPage(
      {super.key, String? this.rid, String? this.rname, String? this.desc});

  @override
  State<RoomInfoPage> createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends State<RoomInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Room',
          style: TextStyle(
            color: Colors.white54,
            fontFamily: "Radiotechnika",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              "Room Name: " +
                  widget.rname +
                  "\n\nRoom Id: " +
                  widget.rid +
                  "\n\nRoom Desc: " +
                  widget.desc,
              style: const TextStyle(
                color: Colors.white54,
                fontFamily: "SpecialGothic",
                fontSize: 18,
              ),
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.all(115),
          //   child: Image(
          //     image: AssetImage('assets/onizuka.png'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
