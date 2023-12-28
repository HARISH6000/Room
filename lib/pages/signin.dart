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
      body: Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 200,
                  child: TextFormField(
                    controller: userIdController,
                    style: const TextStyle(
                      color: Colors.white54,
                    ),
                    decoration: InputDecoration(
                      label: const Text(
                        'User Name',
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onTapOutside: (value) async {
                      FocusScope.of(context).unfocus();
                    },
                    onEditingComplete: () {
                      try {
                        FocusScope.of(context).unfocus();
                        if (userIdController.text.isNotEmpty) {
                          _auth.signInAnonymously().then((value) {
                            print(value);
                            if (value.user?.uid != null) {
                              fs.addUsr(value.user?.uid, userIdController.text);
                            }
                          });
                        }
                      } on Exception {
                        // TODO
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
