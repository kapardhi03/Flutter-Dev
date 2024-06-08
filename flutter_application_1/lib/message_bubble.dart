import 'package:flutter/material.dart';
import 'message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isBot = message.isBot;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isBot)
            const CircleAvatar(
              backgroundImage: AssetImage('/Users/kapardhikannekanti/Flutter-Dev/flutter_application_1/lib/assets/logo.jpg'),
              radius: 20,
            ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isBot ? const Color(0xFF2E2E2E) : const Color(0xFF0D47A1),
                    borderRadius: BorderRadius.only(
                      topLeft: isBot ? Radius.circular(0) : Radius.circular(15),
                      topRight: isBot ? Radius.circular(15) : Radius.circular(0),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Text(
                        isBot ? 'AVA' : 'You',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        message.content,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isBot)
            const SizedBox(width: 10),
          if (!isBot)
            const CircleAvatar(
              backgroundImage: AssetImage('/Users/kapardhikannekanti/Flutter-Dev/flutter_application_1/lib/assets/user.jpg'),
              radius: 20,
            ),
        ],
      ),
    );
  }
}