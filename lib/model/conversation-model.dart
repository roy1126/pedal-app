class Conversation {
  String messageId;
  String senderId;
  bool isAutoReply;
  String message;

  Conversation({
    required this.messageId,
    required this.senderId,
    required this.isAutoReply,
    required this.message,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      messageId: json['messageId'],
      senderId: json['senderId'],
      isAutoReply: json['isAutoReply'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'isAutoReply': isAutoReply,
      'message': message,
    };
  }
}
