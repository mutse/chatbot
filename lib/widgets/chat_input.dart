import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../utils/constants.dart';

class ChatInput extends StatefulWidget {
  final Function(types.PartialText) onSendMessage;
  final Function(String) onGenerateImage;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onGenerateImage,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  bool _isGeneratingImage = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    if (_isGeneratingImage) {
      widget.onGenerateImage(text);
    } else {
      widget.onSendMessage(types.PartialText(text: text));
    }

    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isGeneratingImage ? Icons.chat : Icons.image,
                  color: _isGeneratingImage ? Theme.of(context).primaryColor : null,
                ),
                onPressed: () {
                  setState(() {
                    _isGeneratingImage = !_isGeneratingImage;
                  });
                },
                tooltip: _isGeneratingImage ? 'Switch to chat' : 'Generate image',
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: _isGeneratingImage
                        ? 'Describe the image you want to generate...'
                        : 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.defaultPadding,
                      vertical: AppConstants.defaultPadding / 2,
                    ),
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ],
          ),
          if (_isGeneratingImage)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.defaultPadding / 2),
              child: Text(
                'Image generation mode',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
} 