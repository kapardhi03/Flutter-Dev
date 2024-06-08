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
  final OpenAIService _openAIService = OpenAIService();
  bool _isLoading = false;

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
      _controller.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AVA'),
        titleTextStyle: const TextStyle(
        color: Color.fromARGB(255, 131, 134, 135),
        fontFamily: 'SF Pro Display', // or any other sans-serif font
        fontWeight: FontWeight.w600, // adjust the font weight as desired
        letterSpacing: -0.5, // adjust the letter spacing as desired
      ),

        backgroundColor: Color.fromARGB(221, 29, 25, 25),
      ),
      backgroundColor: const Color.fromARGB(255, 38, 37, 37),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(
                      color: Colors.white, // Set the typed text color here
                    ),

                    decoration: const InputDecoration(
                      hintText: 'Enter your message',
                      hintStyle: TextStyle(
                          color: Colors.grey, // Change the color value as desired
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                        hoverColor: Colors.grey
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}