import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:skuld/database/database_service.dart';
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
  final DatabaseService _db = DatabaseService();
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
        TileToggle(
          label: CText.textGameMode,
          description: CText.textGameModeContent,
          value: _settings.getGameMode(),
          onChanged: _setGameMode,
        ),
        TileButton(label: CText.textNote, icon: Icons.edit_rounded, onPressed: _openNotePage),
        TileDropdown(
          label: CText.textDeletionFrequency,
          dropdownLabel: CText.textDropdownFrequency,
          description: CText.textDeletionFrequencyContent,
          value: _deletionFrequency,
          options: deletionFrequencies,
          onChanged: _setDeletionFrequency,
        ),
        TileIconButton(
          label: CText.textDeletePrefs,
          description: CText.textDeletePrefsContent,
          icon: Icons.delete_rounded,
          onPressed: () => Dialogs.deletionDialog(context, _settings.clearSettings),
        ),
        TileIconButton(
          label: CText.textImport,
          description: CText.textImportContent,
          icon: Icons.download_rounded,
          onPressed: _importData,
        ),
        TileIconButton(
          label: CText.textExport,
          description: CText.textExportContent,
          icon: Icons.upload_rounded,
          onPressed: _exportData,
        ),
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

  Future<void> _importData() async {
    final String? path = (await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['json'],
    ))?.paths.first;
    if (path == null) return;
    final String result = await _db.importData(path);
    _showSnackBar(result);
  }

  Future<void> _exportData() async {
    final String? path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    final String result = await _db.exportData(path);
    _showSnackBar(result);
  }

  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}