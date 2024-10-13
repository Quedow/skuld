import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:skuld/screens/home_screen.dart';

void main() {
  runApp(MyGameApp());
}

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // Add your game logic here if needed
  }
}
