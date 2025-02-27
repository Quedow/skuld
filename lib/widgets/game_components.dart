import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/player.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/providers/quest_provider.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const StatBar({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Row(
      children: [
        Text(label, style: themeData.textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w700, color: color)),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: themeData.unselectedWidgetColor,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(20),
            minHeight: 5,
          ),
        ),
      ],
    );
  }
}

class PlayerStats extends StatelessWidget {
  final DatabaseService db;

  const PlayerStats({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return StreamBuilder<Player>(
      stream: db.watchPlayer(),
      builder: (BuildContext context, AsyncSnapshot<Player> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text(CText.errorLoadingPlayer, style: themeData.textTheme.bodyLarge!.copyWith(color: themeData.colorScheme.primary)));
        }

        final Player player = snapshot.data!;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PlayerStat(trailing: '⚔️', label: 'LEVEL', value: player.level),
            PlayerStat(icon: Icons.favorite_rounded, label: 'HEALTH', value: player.hp, color: themeData.colorScheme.error),
            PlayerStat(trailing: 'XP', label: '/ ${Functions.getTargetXp(player.level)}', value: player.xp, color: Styles.greenColor),
            PlayerStat(icon: Icons.toll_rounded, label: 'CREDIT', value: player.credits, color: Styles.orangeColor),
          ],
        );
      },
    );
  }
}

class PlayerStat extends StatelessWidget {
  final IconData? icon;
  final String? trailing;
  final String label;
  final int value;
  final Color? color;

  const PlayerStat({super.key, required this.value, required this.label, this.icon, this.trailing, this.color});

  @override
  Widget build(BuildContext context) {
    final double iconHeight = 28;
    final double valueHeight = 3/5 * iconHeight;
    final double labelHeight = 2/5 * iconHeight;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null)
          Icon(icon, color: color, size: iconHeight + 2),
        if (trailing != null)
          Text(trailing!, style: TextStyle(fontSize: iconHeight - 4, height: 1.0, fontWeight: FontWeight.bold, color: color)),
        
        const SizedBox(width: 8.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value.toString(),
              style: TextStyle(fontSize: valueHeight, height: 1.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              label,
              style: TextStyle(fontSize: labelHeight, height: 1.0, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class DailyQuestsBoard extends StatelessWidget {
  const DailyQuestsBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height:  0.4 * MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: themeData.colorScheme.primary, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(width: 1, color: themeData.colorScheme.secondary))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(CText.textDailyQuestsTitle, style: themeData.textTheme.labelMedium!.copyWith(color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<QuestProvider>(
                  builder: (context, questProvider, _) {
                    final List<Quest> quests = questProvider.report.dailyQuests;

                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: quests.isNotEmpty
                              ? ListView.builder(
                                itemCount: quests.length,
                                itemBuilder: (context, index) {
                                  Quest quest = quests[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                                    horizontalTitleGap: 50,
                                    title: Text(quest.title.toUpperCase(), textAlign: TextAlign.left, maxLines: 1, overflow: TextOverflow.ellipsis, style: themeData.textTheme.bodyLarge!.copyWith(color: Colors.white)),
                                    trailing: quest.isDone ? const Icon(Icons.check_rounded, color: Styles.greenColor) : null,
                                  );
                                },
                              )
                              : Center(child: Text(CText.textNoDailyQuest.toUpperCase(), style: themeData.textTheme.bodyMedium!.copyWith(color: Colors.white))),
                          ),
                        ),
                        if (questProvider.report.isPenalty)
                          Text(CText.textIsPenalty.toUpperCase(), style: themeData.textTheme.labelMedium!.copyWith(color: Styles.redColor), textAlign: TextAlign.center,),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}