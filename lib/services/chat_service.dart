import 'dart:async';
import '../models/message.dart';
import '../models/chat_history.dart';
import './api_service.dart';
import './storage_service.dart';

class ChatService {
  final ApiService _apiService;
  final StorageService _storageService;
  final _messageController = StreamController<Message>.broadcast();
  ChatHistory? _currentChat;

  ChatService(this._apiService, this._storageService);

  Stream<Message> get messageStream => _messageController.stream;

  Future<void> startNewChat() async {
    _currentChat = ChatHistory.newChat();
    await _saveCurrentChat();
  }

  Future<void> loadChat(String chatId) async {
    final histories = _storageService.getChatHistories();
    _currentChat = histories.firstWhere((h) => h.id == chatId);
  }

  Future<void> sendMessage(String content) async {
    if (_currentChat == null) {
      await startNewChat();
    }

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    _currentChat!.messages.add(userMessage);
    _messageController.add(userMessage);
    await _saveCurrentChat();

    try {
      final response = await _apiService.sendMessage(content);
      _currentChat!.messages.add(response);
      _messageController.add(response);
      await _saveCurrentChat();
    } catch (e) {
      final errorMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Error: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _currentChat!.messages.add(errorMessage);
      _messageController.add(errorMessage);
      await _saveCurrentChat();
    }
  }

  Future<void> generateImage(String prompt) async {
    if (_currentChat == null) {
      await startNewChat();
    }

    try {
      final imageUrl = await _apiService.generateImage(prompt);
      final imageMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Generated image for: $prompt',
        isUser: false,
        timestamp: DateTime.now(),
        imageUrl: imageUrl,
        type: MessageType.image,
      );

      _currentChat!.messages.add(imageMessage);
      _messageController.add(imageMessage);
      await _saveCurrentChat();
    } catch (e) {
      final errorMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Error generating image: ${e.toString()}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      _currentChat!.messages.add(errorMessage);
      _messageController.add(errorMessage);
      await _saveCurrentChat();
    }
  }

  Future<void> _saveCurrentChat() async {
    if (_currentChat == null) return;

    final histories = _storageService.getChatHistories();
    final index = histories.indexWhere((h) => h.id == _currentChat!.id);
    
    if (index >= 0) {
      histories[index] = _currentChat!;
    } else {
      histories.add(_currentChat!);
    }

    await _storageService.saveChatHistories(histories);
  }

  void dispose() {
    _messageController.close();
  }
} 