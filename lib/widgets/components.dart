import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skuld/database/database_service.dart';
import 'package:skuld/models/player.dart';
import 'package:skuld/models/quest.dart';
import 'package:skuld/provider/quest_provider.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/utils/functions.dart';
import 'package:skuld/utils/styles.dart';

class TileDropdown extends StatelessWidget {
  final String label;
  final String dropdownLabel;
  final String description;
  final String value;
  final Map<String, String> options;
  final void Function(String?)? onChanged;

  const TileDropdown({super.key, required this.label, required this.dropdownLabel, required this.description, required this.value, required this.onChanged, required this.options});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
      trailing: IntrinsicWidth(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(labelText: dropdownLabel),
          onChanged: onChanged,
          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value, style: Theme.of(context).textTheme.labelLarge),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class TileIconButton extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final void Function() onPressed;

  const TileIconButton({super.key, required this.label, required this.description, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class TileButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onPressed;

  const TileButton({super.key, required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: Theme.of(context).hintColor),
    );
  }
}

class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const StatBar({super.key, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium!.copyWith(fontWeight: FontWeight.w700, color: color)),
        const SizedBox(width: 10),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Theme.of(context).unselectedWidgetColor,
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
    return StreamBuilder<Player>(
      stream: db.watchPlayer(),
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
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height:  0.4 * MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondary))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Colors.white),
                    const SizedBox(width: 5),
                    Text(CText.textDailyQuestsTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
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
                                    title: Text(quest.title.toUpperCase(), textAlign: TextAlign.left, maxLines: 1, style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis)),
                                    trailing: quest.isDone ? const Icon(Icons.check_rounded, color: Styles.greenColor) : null,
                                  );
                                },
                              )
                              : Center(child: Text(CText.textNoDailyQuest.toUpperCase(), style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white))),
                          ),
                        ),
                        if (questProvider.report.isPenalty)
                          Text(CText.textIsPenalty.toUpperCase(), style: const TextStyle(color: Styles.redColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
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