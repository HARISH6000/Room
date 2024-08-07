import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room/pages/home.dart';
import 'package:room/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room/pages/signinWithEmail.dart';

// ignore: camel_case_types
class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {
  final userIdController = TextEditingController();
  final pswdController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    FirebaseFirestoreServices fs = FirebaseFirestoreServices();
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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const signinWithEmailPage()));
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Text(
              'Login',
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
                  'User name',
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
              onFieldSubmitted: (value) {
                print("---------------------------------------------\n\n\n");
                print(userIdController.text);
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
                try {
                  _auth
                      .signInWithEmailAndPassword(
                          email: userIdController.text, password: value)
                      .then((value) {
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
              },
            ),
          ),
          // const Padding(
          //   padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
          //   child: Image(
          //     image: AssetImage('assets/onizuka.png'),
          //   ),
          // ),
        ],
      ),
      backgroundColor: colorScheme.background,
    );
  }
}
