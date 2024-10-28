import 'package:flutter/material.dart';
import 'package:skuld/provider/settings_service.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/widgets/alerts.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _settings = SettingsService();
  final Map<String, String> deletionFrequencies = const {
    '1w': '1 week',
    '2w': '2 weeks',
    '1m': '1 month',
    '1y': '1 year',
    'n': 'Never',
  };
  late String _deletionFrequency;

  @override
  void initState() {
    super.initState();
    _deletionFrequency = _settings.getDeletionFrequency();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _settingDropdown(Texts.textDeletionFrequency, Texts.textDeletionFrequencyContent, _deletionFrequency, _setDeletionFrequency),
        const Divider(height: 1, thickness: 1),
        _settingIconButton(Texts.textDeletePrefs, Texts.textDeletePrefsContent, Icons.delete_rounded, () => Alerts.deletionDialog(context, _settings.clearSettings)),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }

  ListTile _settingDropdown(String label, String description, String value, void Function(String?)? onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
      trailing: IntrinsicWidth(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(labelText: 'Frequency'),
          onChanged: onChanged,
          items: deletionFrequencies.entries.map((entry) => DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value, style: Theme.of(context).textTheme.labelLarge),
          ),).toList(),
        ),
      ),
    );
  }

  ListTile _settingIconButton(String label, String description, IconData icon, void Function() onPressed) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
      trailing: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }

  void _setDeletionFrequency(String? value) {
    if (value != null) {
      _settings.setDeletionFrequency(value);
    }
  }
}