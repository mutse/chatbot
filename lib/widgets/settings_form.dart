import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _apiUrlController;
  late TextEditingController _apiKeyController;
  late TextEditingController _modelNameController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<Settings>();
    _apiUrlController = TextEditingController(text: settings.apiUrl);
    _apiKeyController = TextEditingController(text: settings.apiKey);
    _modelNameController = TextEditingController(text: settings.modelName);
  }

  @override
  void dispose() {
    _apiUrlController.dispose();
    _apiKeyController.dispose();
    _modelNameController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;

    final storageService = context.read<StorageService>();
    final newSettings = Settings(
      apiUrl: _apiUrlController.text,
      apiKey: _apiKeyController.text,
      modelName: _modelNameController.text,
    );

    await storageService.saveSettings(newSettings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _apiUrlController,
            decoration: const InputDecoration(
              labelText: 'API URL',
              hintText: AppConstants.defaultApiUrl,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter API URL';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          TextFormField(
            controller: _apiKeyController,
            decoration: const InputDecoration(
              labelText: 'API Key',
              hintText: 'Enter your API key',
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter API key';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          TextFormField(
            controller: _modelNameController,
            decoration: const InputDecoration(
              labelText: 'Model Name',
              hintText: AppConstants.defaultModel,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter model name';
              }
              return null;
            },
          ),
          const SizedBox(height: AppConstants.defaultPadding * 2),
          ElevatedButton(
            onPressed: _saveSettings,
            child: const Text('Save Settings'),
          ),
        ],
      ),
    );
  }
} 