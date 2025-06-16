import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Message {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final MessageType type;

  Message({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.type = MessageType.text,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imageUrl: json['imageUrl'] as String?,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'type': type.toString(),
    };
  }

  types.Message toChatMessage() {
    return types.TextMessage(
      author: types.User(id: isUser ? 'user' : 'bot'),
      id: id,
      text: content,
      createdAt: timestamp.millisecondsSinceEpoch,
    );
  }
}

enum MessageType {
  text,
  image,
  markdown,
} 