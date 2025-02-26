import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/widgets/components.dart';

class GameScreen extends StatefulWidget {
  final QuestProvider questProvider;

  const GameScreen({super.key, required this.questProvider});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final DatabaseService _db = DatabaseService();
  late final QuestProvider _questProvider;

  @override
  void initState() {
    super.initState();
    _questProvider = widget.questProvider;
    _questProvider.fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SizedBox(
            height: 130,
            width: 100,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person_rounded, size: 65),
            ),
          ),
          const SizedBox(height: 25),
          PlayerStats(db: _db),
          const DailyQuestsBoard(),
        ],
      ),
    );
  }
}