import 'package:flutter/material.dart';
import 'message_bubble.dart';
import 'message_model.dart';
import 'openai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final OpenAIService _openAIService = OpenAIService();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String content) {
    if (content.trim().isNotEmpty) {
      final message = Message(
        content: content.trim(),
        timestamp: DateTime.now(),
        isBot: false,
      );
      setState(() {
        _messages.add(message);
        _isLoading = true;
      });
      _scrollToBottom();
      _controller.clear();
      _focusNode.requestFocus(); // Request focus on the text field
      _scrollToBottom();
      _botResponse(content.trim());
    }
  }

  Future<void> _botResponse(String userMessage) async {
    try {
      final botResponse = await _openAIService.getResponse(userMessage);
      final botMessage = Message(
        content: botResponse,
        timestamp: DateTime.now(),
        isBot: true,
      );
      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });
      // _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error getting bot response: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get response from AVA: $e')),
      );
    }
  }

  void _scrollToBottom() {
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    final currentPosition = _scrollController.position.pixels;
    final difference = maxScrollExtent - currentPosition;

    if (difference > 0) {
      _scrollController.animateTo(
        maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVA'),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 131, 134, 135),
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
        backgroundColor: const Color.fromARGB(221, 29, 25, 25),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 37, 37),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (ctx, index) {
                if (index == _messages.length) {
                  return const LoadingSkeleton();
                }
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.deepPurpleAccent.shade200),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, child) {
                    return IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: value.text.isEmpty
                          ? null
                          : () => _sendMessage(value.text),
                      color: value.text.isEmpty
                          ? Colors.grey
                          : Colors.deepPurpleAccent.shade200,
                      disabledColor: Colors.grey,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 16,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            width: double.infinity,
            height: 16,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            width: 100,
            height: 16,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }
}
