class AppConstants {
  static const String appName = 'AI Chatbot';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const String defaultApiUrl = 'https://api.openai.com/v1';
  static const String defaultModel = 'gpt-3.5-turbo';
  
  // Storage Keys
  static const String settingsKey = 'settings';
  static const String chatHistoriesKey = 'chat_histories';
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultIconSize = 24.0;
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // Error Messages
  static const String errorNoApiKey = 'Please set your API key in settings';
  static const String errorNoApiUrl = 'Please set your API URL in settings';
  static const String errorNoModel = 'Please select a model in settings';
  static const String errorNetwork = 'Network error occurred';
  static const String errorUnknown = 'An unknown error occurred';
} 