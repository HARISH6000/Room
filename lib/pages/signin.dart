import 'package:cloud_firestore/cloud_firestore.dart';
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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
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
        backgroundColor: colorScheme.background,
        elevation: 0.0,
      ),
      body: Row(
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
                  style: TextStyle(
                    color: colorScheme.secondary,
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
                            fs.addUsr(
                              value.user?.uid,
                              userIdController.text,
                              true,
                            );
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
      backgroundColor: colorScheme.background,
    );
  }
}
