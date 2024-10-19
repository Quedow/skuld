import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int hp = 100;
  int exp = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Player HP: $hp'),
        Text('Player EXP: $exp'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              exp += 10;
            });
          },
          child: const Text('Gain EXP'),
        ),
      ],
    );
  }
}