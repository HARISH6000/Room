import 'package:flutter/material.dart';
import 'package:room/pages/instruction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:room/pages/room.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:room/pages/signin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String roomno = '', temp = '';
  final _txt_controller = TextEditingController();
  bool isSignedIn = true;
  DocumentSnapshot? us;

  Future<AlertDialog?> _vercheck(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    DocumentSnapshot ds = await db.collection("Info").doc('version').get();
    print(version + "----" + ds['verNo'].split(".")[2]);
    if ((int.parse(ds['verNo'].split(".")[0]) >
            int.parse(version.split(".")[0])) ||
        ((int.parse(ds['verNo'].split(".")[0]) ==
                int.parse(version.split(".")[0])) &&
            (int.parse(ds['verNo'].split(".")[1]) >
                int.parse(version.split(".")[1]))) ||
        ((int.parse(ds['verNo'].split(".")[0]) ==
                int.parse(version.split(".")[0])) &&
            (int.parse(ds['verNo'].split(".")[1]) ==
                int.parse(version.split(".")[1])) &&
            (int.parse(ds['verNo'].split(".")[2]) >
                int.parse(version.split(".")[2])))) {
      _showAlertDialog(context, ds);
    }
    return null;
  }

  void _showAlertDialog(BuildContext context, DocumentSnapshot ds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ds["title"]),
          content: Text(ds["content"] +
              "\n\nNote: if you have already downloaded the latest version, install it."),
          actions: [
            TextButton(
              onPressed: () async {
                Uri _url = Uri.parse(ds['download']);
                if (await launchUrl(_url)) {
                  print("successful");
                  Navigator.of(context).pop();
                } else {
                  throw 'could not open the url';
                }
              },
              child: const Text("Download"),
            ),
            TextButton(
              onPressed: () async {
                Uri _url = Uri.parse(ds['learnMore']);
                if (await launchUrl(_url)) {
                  print("successful");
                  Navigator.of(context).pop();
                } else {
                  throw 'could not open the url';
                }
              },
              child: const Text("Learn more"),
            )
          ],
        );
      },
    );
  }

  void _signinCheck() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      print("--------------------------------------");
      print(user);
      if (user == null) {
        print('User not signed in');
        setState(() {
          isSignedIn = false;
        });
      } else {
        //FirebaseFirestore db = FirebaseFirestore.instance;
        us = await db.collection("User").doc(user.uid).get();
        print('User is signed in!');
        setState(() {
          isSignedIn = true;
        });
      }
    });
    //FirebaseAuth.instance.signOut();
    // print("----------------signed out-------------------");
  }

  @override
  void initState() {
    super.initState();
    _vercheck(context);
    _signinCheck();
    // FirebaseAuth.instance.signOut();
    // print("----------------signed out-------------------");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return isSignedIn
        ? Scaffold(
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
                IconButton(
                  onPressed: () async {
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
                      print("----------------signed out-------------------");
                    }
                  },
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
              backgroundColor: colorScheme.background,
              elevation: 0.0,
            ),
            backgroundColor: colorScheme.background,
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
                          db.collection("Room").doc(str).get().then(
                              (DocumentSnapshot ds) {
                            print("query successful");
                            print(ds);
                            if (!ds.exists) {
                              setState(() {
                                roomno += ".\nThis room does not exist.";
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = false;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RoomPage(
                                              rid: str,
                                              rname: ds["rname"],
                                              desc: ds["desc"],
                                              us: us,
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
                        cursorColor: colorScheme.primary.withAlpha(
                            159), //const Color.fromARGB(159, 104, 58, 183),
                        decoration: InputDecoration(
                          isCollapsed: false,
                          isDense: false,
                          fillColor: colorScheme.background,
                          filled: true,
                          hintStyle: const TextStyle(color: Colors.white54),
                          hintText: 'Room',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: colorScheme.tertiary, width: 1),
                              borderRadius: BorderRadius.circular(100)),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: colorScheme.primary, width: 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 244, 67, 54),
                                width: 1),
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
                              color: colorScheme.primary,
                            )
                          : Container(
                              child: Text(
                                temp + roomno,
                                style: TextStyle(
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : const SigninPage();
  }
}
