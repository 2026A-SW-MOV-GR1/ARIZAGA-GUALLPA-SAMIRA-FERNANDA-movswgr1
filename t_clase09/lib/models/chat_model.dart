enum MessageType { text, link, call }

class ChatMessage {
  final String sender;
  final String text;
  final MessageType type;
  final String? subText; // Para duración de llamadas o info del link

  ChatMessage({
    required this.sender,
    required this.text,
    this.type = MessageType.text,
    this.subText,
  });
}

class ChatModel {
  final String title;
  final String msg;
  final String time;
  final bool isPin;
  final List<ChatMessage> messages;

  ChatModel({
    required this.title,
    required this.msg,
    required this.time,
    required this.isPin,
    required this.messages,
  });
}
