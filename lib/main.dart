import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'screens/about_screen.dart';
import 'models/settings.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/chat_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  final settings = storageService.getSettings() ?? Settings.defaultSettings();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        Provider.value(value: storageService),
        ProxyProvider2<Settings, StorageService, ApiService>(
          update: (_, settings, storage, __) => ApiService(settings),
        ),
        ProxyProvider2<ApiService, StorageService, ChatService>(
          update: (_, api, storage, __) => ChatService(api, storage),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Settings>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'AI Chatbot',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => const ChatScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/history': (context) => const HistoryScreen(),
            '/about': (context) => const AboutScreen(),
          },
        );
      },
    );
  }
} 