import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings.dart';
import '../models/chat_history.dart';

class StorageService {
  static const String _settingsKey = 'settings';
  static const String _chatHistoriesKey = 'chat_histories';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<void> saveSettings(Settings settings) async {
    await _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  Settings? getSettings() {
    final settingsJson = _prefs.getString(_settingsKey);
    if (settingsJson == null) return null;
    return Settings.fromJson(jsonDecode(settingsJson));
  }

  Future<void> saveChatHistories(List<ChatHistory> histories) async {
    final historiesJson = histories.map((h) => h.toJson()).toList();
    await _prefs.setString(_chatHistoriesKey, jsonEncode(historiesJson));
  }

  List<ChatHistory> getChatHistories() {
    final historiesJson = _prefs.getString(_chatHistoriesKey);
    if (historiesJson == null) return [];
    
    final List<dynamic> decoded = jsonDecode(historiesJson);
    return decoded.map((json) => ChatHistory.fromJson(json)).toList();
  }

  Future<void> deleteChatHistory(String id) async {
    final histories = getChatHistories();
    histories.removeWhere((h) => h.id == id);
    await saveChatHistories(histories);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
} 