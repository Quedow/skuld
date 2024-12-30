import 'package:flutter/material.dart';

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
