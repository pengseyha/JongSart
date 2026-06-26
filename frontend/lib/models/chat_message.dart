class ChatMessage {
  final String id;
  final String text;
  final bool isMe;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isMe,
    required this.sentAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isMe': isMe,
      'sentAt': sentAt.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String? ?? '',
      isMe: json['isMe'] as bool? ?? false,
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
