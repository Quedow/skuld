import 'package:flutter/material.dart';
import 'package:skuld/provider/settings_service.dart';
import 'package:skuld/utils/common_text.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final SettingsService _settings = SettingsService();
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: _settings.getNoteContent());
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CText.textNote),
        actions: [
          IconButton(onPressed: _saveNoteContent, icon: Icon(Icons.save_rounded, color: Theme.of(context).colorScheme.primary)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextFormField(
                maxLines: null,
                controller: _noteController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  label: Text(
                    CText.textNoteLabel,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveNoteContent() {
    FocusScope.of(context).unfocus();
    _settings.setNoteContent(_noteController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(CText.textNoteSaved),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
}