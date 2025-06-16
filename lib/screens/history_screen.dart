import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/chat_history.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: Consumer<StorageService>(
        builder: (context, storageService, child) {
          final histories = storageService.getChatHistories();
          
          if (histories.isEmpty) {
            return const Center(
              child: Text('No chat history yet'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: histories.length,
            itemBuilder: (context, index) {
              final history = histories[index];
              return Dismissible(
                key: Key(history.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  storageService.deleteChatHistory(history.id);
                },
                child: Card(
                  child: ListTile(
                    title: Text(history.title),
                    subtitle: Text(
                      'Last updated: ${DateFormat.yMMMd().add_jm().format(history.updatedAt)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Implement chat loading
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 