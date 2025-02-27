// import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/database/migration.dart';
import 'package:skuld/providers/quest_provider.dart';
import 'package:skuld/providers/settings_service.dart';
import 'package:skuld/screens/home_screen.dart';
import 'package:skuld/utils/styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await SettingsService().init();
  final Isar isar = await DatabaseService().init();
  await performMigrationIfNeeded(isar);

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
    return MaterialApp(
      home: const HomeScreen(),
      theme: Styles.themeData,
      locale: const Locale('en', 'GB'),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [
        const Locale('en', 'GB'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

/* class MyGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    // Add your game logic here if needed
  }
} */
