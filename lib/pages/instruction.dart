import 'package:flutter/material.dart';
import 'package:room/pages/login.dart';

class Instruction extends StatelessWidget {
  const Instruction({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(100, 0, 75, 0),
            child: Text(
              'For now, only admins are allowed to create room.',
              style: TextStyle(
                color: colorScheme.tertiary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 75, 75),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const loginPage()));
              },
              child: const Text('I know'),
            ),
          ),
        ],
      ),
    );
  }
}
