class Message {
  final String content;
  final DateTime timestamp;
  final bool isBot;

  Message({
    required this.content,
    required this.timestamp,
    this.isBot = false,
  });
}