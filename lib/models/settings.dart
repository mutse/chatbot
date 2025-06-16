import 'package:flutter/foundation.dart';

class Settings extends ChangeNotifier {
  String _apiUrl;
  String _apiKey;
  String _modelName;
  bool _darkMode;

  Settings({
    required String apiUrl,
    required String apiKey,
    required String modelName,
    bool darkMode = false,
  })  : _apiUrl = apiUrl,
        _apiKey = apiKey,
        _modelName = modelName,
        _darkMode = darkMode;

  String get apiUrl => _apiUrl;
  String get apiKey => _apiKey;
  String get modelName => _modelName;
  bool get darkMode => _darkMode;

  set apiUrl(String value) {
    _apiUrl = value;
    notifyListeners();
  }

  set apiKey(String value) {
    _apiKey = value;
    notifyListeners();
  }

  set modelName(String value) {
    _modelName = value;
    notifyListeners();
  }

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  factory Settings.defaultSettings() {
    return Settings(
      apiUrl: 'https://api.openai.com/v1',
      apiKey: '',
      modelName: 'gpt-3.5-turbo',
    );
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      apiUrl: json['apiUrl'] as String,
      apiKey: json['apiKey'] as String,
      modelName: json['modelName'] as String,
      darkMode: json['darkMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiUrl': _apiUrl,
      'apiKey': _apiKey,
      'modelName': _modelName,
      'darkMode': _darkMode,
    };
  }

  Settings copyWith({
    String? apiUrl,
    String? apiKey,
    String? modelName,
    bool? darkMode,
  }) {
    return Settings(
      apiUrl: apiUrl ?? _apiUrl,
      apiKey: apiKey ?? _apiKey,
      modelName: modelName ?? _modelName,
      darkMode: darkMode ?? _darkMode,
    );
  }
} 