import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room/pages/home.dart';
import 'package:room/services/firestore_services.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final userIdController = TextEditingController();
  final pswdController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    FirebaseFirestoreServices fs = FirebaseFirestoreServices();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Room',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Radiotechnika',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              controller: userIdController,
              style: const TextStyle(
                color: Colors.white54,
              ),
              decoration: InputDecoration(
                label: const Text(
                  'User Id',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: TextFormField(
              obscureText: true,
              controller: pswdController,
              style: const TextStyle(
                color: Colors.white54,
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
                print(value);
                try {
                  _auth.signInAnonymously().then((value) {
                    print(value);
                    if (value.user?.uid != null) {
                      fs.addUsr(value.user?.uid, userIdController.text);
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      });
                    }
                  });
                } on Exception {
                  // TODO
                }
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
