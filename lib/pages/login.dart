import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room/pages/home.dart';

// ignore: camel_case_types
class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

// ignore: camel_case_types
class _loginPageState extends State<loginPage> {
  String _uName = '';
  final userName_Controller = TextEditingController();
  final pass_Controler = TextEditingController();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
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
          const Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 20),
            child: Text(
              'Login',
              style: TextStyle(
                color: Colors.deepPurple,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 20),
            child: TextFormField(
              controller: userName_Controller,
              style: const TextStyle(
                color: Colors.white54,
              ),
              decoration: InputDecoration(
                label: const Text(
                  'User name',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onEditingComplete: () {
                setState(() {
                  _uName = userName_Controller.text;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 0, 50.0, 150),
            child: TextFormField(
              obscureText: true,
              controller: pass_Controler,
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
                  _auth
                      .signInWithEmailAndPassword(
                          email: _uName, password: value)
                      .then((value) {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    });
                  });
                } on Exception {
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
      backgroundColor: Colors.black,
    );
  }
}
