import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room/pages/home.dart';
import 'package:room/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: camel_case_types
class signinWithEmailPage extends StatefulWidget {
  const signinWithEmailPage({super.key});

  @override
  State<signinWithEmailPage> createState() => _signinWithEmailPageState();
}

// ignore: camel_case_types
class _signinWithEmailPageState extends State<signinWithEmailPage> {
  final userIdController = TextEditingController();
  final userNameController = TextEditingController();
  final pswdController = TextEditingController();
  final repswdController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    FirebaseFirestoreServices fs = FirebaseFirestoreServices();
    String note = "room";
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Room',
          style: TextStyle(
            color: colorScheme.secondary,
            fontFamily: 'Radiotechnika',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.background,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Text(
              'Signin',
              style: TextStyle(
                color: colorScheme.primary,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 20),
            child: TextFormField(
              controller: userIdController,
              style: TextStyle(
                color: colorScheme.secondary,
              ),
              decoration: InputDecoration(
                label: const Text(
                  'Email',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 20),
            child: TextFormField(
              controller: userNameController,
              style: TextStyle(
                color: colorScheme.secondary,
              ),
              decoration: InputDecoration(
                label: const Text(
                  'User name',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 20),
            child: TextFormField(
              obscureText: true,
              controller: pswdController,
              style: TextStyle(
                color: colorScheme.secondary,
              ),
              decoration: InputDecoration(
                label: const Text(
                  'Password',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 150),
            child: TextFormField(
              obscureText: true,
              controller: repswdController,
              style: TextStyle(
                color: colorScheme.secondary,
              ),
              decoration: InputDecoration(
                label: const Text(
                  'Password',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onFieldSubmitted: (value) {
                print("---------------------------------------------\n\n\n");
                print(userIdController.text);
                print(pswdController.text);
                print(value);
                print(
                    "\n\n\n-------------------------------------------------");
                User? usr = FirebaseAuth.instance.currentUser;
                if (usr != null) {
                  db
                      .collection("User")
                      .doc(usr.uid)
                      .get()
                      .then((DocumentSnapshot ds) async {
                    if (ds.exists) {
                      if (ds["isAnon"] == false) {
                        _auth.signOut();
                      } else {
                        _auth.currentUser!.delete();
                        db.collection("User").doc(usr.uid).delete();
                        await usr.delete();
                      }
                    }
                  });
                }
                if (pswdController.text == value) {
                  try {
                    _auth
                        .createUserWithEmailAndPassword(
                            email: userIdController.text, password: value)
                        .then((value) {
                      if (value.user?.uid != null) {
                        fs.addUsr(
                          value.user?.uid,
                          userNameController.text,
                          false,
                        );
                      }
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      });
                    });
                  } on Exception {
                    print("couldn't, sign in");
                    // TODO
                  }
                } else {
                  setState(() {
                    note = "Password mismatch";
                  });
                }
              },
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
          //   child: Image(
          //     image: AssetImage('assets/onizuka.png'),
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(1),
            child: Text(
              note,
              style: TextStyle(
                color: colorScheme.primary,
              ),
            ),
          )
        ],
      ),
      backgroundColor: colorScheme.background,
    );
  }
}
