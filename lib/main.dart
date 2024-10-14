import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skuld/provider/database_service.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await DatabaseService().init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => QuestProvider(),
      child: const MyGameApp(),
    ),
  );
}

class MyGameApp extends StatelessWidget {
  const MyGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
