import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Center(
              child: Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Version ${AppConstants.appVersion}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding * 2),
            const Text(
              'Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            _buildFeatureItem(
              context,
              'Chat with AI',
              'Have natural conversations with advanced AI models',
              Icons.chat,
            ),
            _buildFeatureItem(
              context,
              'Image Generation',
              'Generate images from text descriptions',
              Icons.image,
            ),
            _buildFeatureItem(
              context,
              'Chat History',
              'Access your past conversations',
              Icons.history,
            ),
            const SizedBox(height: AppConstants.defaultPadding * 2),
            const Text(
              'Links',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Source Code'),
              onTap: () => _launchUrl('https://github.com/yourusername/chatbot'),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Report Issues'),
              onTap: () => _launchUrl('https://github.com/yourusername/chatbot/issues'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Row(
        children: [
          Icon(icon, size: AppConstants.defaultIconSize),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 