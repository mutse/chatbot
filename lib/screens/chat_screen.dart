import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../models/chat_history.dart';
import '../services/chat_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user');
  final _bot = const types.User(id: 'bot');

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    final chatService = context.read<ChatService>();
    chatService.messageStream.listen((message) {
      setState(() {
        _messages.add(message.toChatMessage());
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final chatService = context.read<ChatService>();
    chatService.sendMessage(message.text);
  }

  void _handleImageGeneration(String prompt) {
    final chatService = context.read<ChatService>();
    chatService.generateImage(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.chat_bubble_outline, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Version ${AppConstants.appVersion}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Chat History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
            const Divider(),
            Consumer<StorageService>(
              builder: (context, storage, child) {
                final histories = storage.getChatHistories();
                if (histories.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No chat history yet'),
                  );
                }
                return Column(
                  children: histories.map((history) => ListTile(
                    leading: const Icon(Icons.chat_bubble_outline),
                    title: Text(history.title),
                    subtitle: Text(
                      'Last updated: ${history.updatedAt.toString().split('.')[0]}',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Implement chat loading
                    },
                  )).toList(),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Chat(
              messages: _messages,
              onSendPressed: _handleSendPressed,
              showUserAvatars: true,
              showUserNames: true,
              user: _user,
            ),
          ),
          ChatInput(
            onSendMessage: _handleSendPressed,
            onGenerateImage: _handleImageGeneration,
          ),
        ],
      ),
    );
  }
} 