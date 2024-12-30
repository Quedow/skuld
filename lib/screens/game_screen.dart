import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/player.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';
import 'package:skuld/widgets/components.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final DatabaseService _db = DatabaseService();

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
            playerStats(),
        ],
      ),
    );
  }

  StreamBuilder<Player> playerStats() {
    return StreamBuilder<Player>(
      stream: _db.watchPlayer(),
      builder: (BuildContext context, AsyncSnapshot<Player> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text(CText.errorLoadingPlayer, style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary)));
        }

        final Player player = snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlayerStat(trailing: '⚔️', label: 'LEVEL', value: player.level),
            PlayerStat(icon: Icons.favorite_rounded, label: 'HEALTH', value: player.hp, color: Theme.of(context).colorScheme.error),
            PlayerStat(trailing: 'XP', label: '/ ${Functions.getTargetXp(player.level)}', value: player.xp, color: Styles.greenColor),
            PlayerStat(icon: Icons.toll_rounded, label: 'CREDIT', value: player.credits, color: Styles.orangeColor),
          ],
        );
      },
    );
  }
}