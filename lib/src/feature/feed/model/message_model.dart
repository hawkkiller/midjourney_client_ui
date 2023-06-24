base class MessageModel {
  const MessageModel({
    required this.id,
    this.title,
    this.uri,
  });
  
  final String? uri;
  final String id;
  final String? title;
}
