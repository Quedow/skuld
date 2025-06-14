import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/providers/quest_provider.dart';
import 'package:skuld/providers/settings_service.dart';
import 'package:skuld/screens/game_screen.dart';
import 'package:skuld/screens/quests_screen.dart';
import 'package:skuld/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _gameMode = SettingsService().getGameMode();
  late final QuestProvider _questProvider;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _questProvider = Provider.of<QuestProvider>(context, listen: false);
    _screens.addAll([
      if (_gameMode) GameScreen(questProvider: _questProvider),
      QuestsScreen(questProvider: _questProvider),
      const SettingsScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuestProvider>(
          builder: (context, questProvider, _) => IndexedStack(
            index: questProvider.currentScreenIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: Consumer<QuestProvider>(
        builder: (context, questProvider, _) => BottomNavigationBar(
          currentIndex: questProvider.currentScreenIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: questProvider.updateScreenIndex,
          items:  [
            if (_gameMode) const BottomNavigationBarItem(label: 'Game', icon: Icon(Icons.videogame_asset_rounded)),
            const BottomNavigationBarItem(label: 'Quests', icon: Icon(Icons.checklist_rounded)),
            const BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings_rounded)),
          ],
        ),
      ),
    );
  }
}