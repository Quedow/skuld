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
    final ThemeData themeData = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: themeData.textTheme.bodyLarge),
      subtitle: Text(description, style: themeData.textTheme.bodySmall),
      trailing: IntrinsicWidth(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(labelText: dropdownLabel),
          onChanged: onChanged,
          items: options.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value, style: themeData.textTheme.labelLarge),
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
    final ThemeData themeData = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: themeData.textTheme.bodyLarge),
      subtitle: Text(description, style: themeData.textTheme.bodySmall),
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
    final ThemeData themeData = Theme.of(context);
    return ListTile(
      onTap: onPressed,
      leading: Icon(icon),
      title: Text(label, style: themeData.textTheme.bodyLarge),
      trailing: Icon(Icons.arrow_forward_ios_rounded, color: themeData.hintColor),
    );
  }
}

class TileToggle extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const TileToggle({super.key, required this.label, required this.description, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}