class ChatMessage {
  final String type;
  final String message;
  final int from;

  static const IMAGE = "image";
  static const TEXT = "text";
  static const FILE = "file";

  const ChatMessage({
    required this.type,
    required this.message,
    required this.from,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message': message,
      'from': from
    };
  }

  factory ChatMessage.fromMap(Map<dynamic, dynamic> map) {
    return ChatMessage(
      type: map['type'] as String,
      message: map['message'] as String,
      from: map['from'] as int,
    );
  }
}