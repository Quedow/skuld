import 'package:flutter/material.dart';
import 'package:skuld/pages/note_page.dart';
import 'package:skuld/providers/settings_service.dart';
import 'package:skuld/utils/common_text.dart';
import 'package:skuld/widgets/overlays.dart';
import 'package:skuld/widgets/settings_components.dart';

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
        TileDropdown(
          label: CText.textDeletionFrequency,
          dropdownLabel: CText.textDropdownFrequency,
          description: CText.textDeletionFrequencyContent,
          value: _deletionFrequency,
          options: deletionFrequencies,
          onChanged: _setDeletionFrequency,
        ),
        TileToggle(
          label: CText.textGameMode,
          description: CText.textGameModeContent,
          value: _settings.getGameMode(),
          onChanged: _setGameMode,
        ),
        TileIconButton(
          label: CText.textDeletePrefs,
          description: CText.textDeletePrefsContent,
          icon: Icons.delete_rounded,
          onPressed: () => Overlays.deletionDialog(context, _settings.clearSettings),
        ),
        TileButton(label: CText.textNote, icon: Icons.edit_rounded, onPressed: _openNotePage),
      ],
    );
  }

  void _setDeletionFrequency(String? value) {
    if (value != null) {
      _settings.setDeletionFrequency(value);
    }
  }

  void _setGameMode(bool value) {
    setState(() {
      _settings.setGameMode(value);
    });
  }

  void _openNotePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NotePage()));
  }
}