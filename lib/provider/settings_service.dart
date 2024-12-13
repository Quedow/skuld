import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  static SharedPreferences? _preferences;

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> setNoteContent(String content) async {
    await _preferences!.setString('note', content);
  }

  String getNoteContent() {
    return _preferences!.getString('note') ?? '';
  }

  Future<void> setDeletionFrequency(String value) async {
    await _preferences!.setString('deletionFrequency', value);
  }

  String getDeletionFrequency() {
    return _preferences!.getString('deletionFrequency') ?? '1m';
  }

  Future<void> clearSettings() async {
    await _preferences!.remove('deletionFrequency');
  }
}