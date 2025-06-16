import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/settings.dart';
import '../models/message.dart';

class ApiService {
  final Settings settings;

  ApiService(this.settings);

  Future<Message> sendMessage(String content) async {
    final response = await http.post(
      Uri.parse('${settings.apiUrl}/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${settings.apiKey}',
      },
      body: jsonEncode({
        'model': settings.modelName,
        'messages': [
          {
            'role': 'user',
            'content': content,
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final assistantMessage = data['choices'][0]['message']['content'];
      
      return Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: assistantMessage,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } else {
      throw Exception('Failed to send message: ${response.statusCode}');
    }
  }

  Future<String> generateImage(String prompt) async {
    final response = await http.post(
      Uri.parse('${settings.apiUrl}/images/generations'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${settings.apiKey}',
      },
      body: jsonEncode({
        'prompt': prompt,
        'n': 1,
        'size': '1024x1024',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'][0]['url'];
    } else {
      throw Exception('Failed to generate image: ${response.statusCode}');
    }
  }
} 