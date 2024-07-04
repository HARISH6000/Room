import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on Exception catch (e) {
    // ignore: avoid_print
    print("error:");
    // ignore: avoid_print
    print(e);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Colors.deepPurple,
      background: Colors.black,
      secondary: Colors.white54,
      tertiary: Colors.white,
    );
    final ColorScheme colorScheme1 = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Colors.blueAccent.shade400,
      background: Colors.black,
      secondary: Colors.white54,
      tertiary: Colors.white,
    );
    final ColorScheme colorScheme2 = ColorScheme.fromSeed(
      brightness: MediaQuery.platformBrightnessOf(context),
      seedColor: Colors.deepPurple,
      background: Colors.white,
      secondary: Colors.grey,
      tertiary: Colors.black,
    );
    return MaterialApp(
      theme: ThemeData(
        colorScheme: colorScheme,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
