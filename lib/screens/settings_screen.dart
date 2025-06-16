import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/settings_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Configuration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            const SettingsForm(),
            const SizedBox(height: AppConstants.defaultPadding * 2),
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Consumer<Settings>(
              builder: (context, settings, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: settings.darkMode,
                  onChanged: (value) async {
                    final storageService = context.read<StorageService>();
                    final newSettings = settings.copyWith(darkMode: value);
                    await storageService.saveSettings(newSettings);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
} 