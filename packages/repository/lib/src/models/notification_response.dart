class NotificationResponse {
  late num id;
  late String type;
  late String title;
  late String content;
  late String priority;
  late String createdAt;
  late bool seen;
  late String? seenAt;

  NotificationResponse({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.priority,
    required this.createdAt,
    required this.seen,
    required this.seenAt
  });

  static Map<String, dynamic> toMap(NotificationResponse data) {
    return {
      'id': data.id,
      'type': data.type,
      'title': data.title,
      'content': data.content,
      'priority': data.priority,
      'createdAt': data.createdAt,
      'seen': data.seen,
      'seenAt': data.seenAt,
    };
  }

  static NotificationResponse fromMap(Map<String, dynamic> map) {
    return NotificationResponse(
      id: map['id'],
      type: map['type'],
      title: map['title'],
      content: map['content'],
      priority: map['priority'],
      createdAt: map['createdAt'],
      seen: map['seen'],
      seenAt: map['seenAt'],
    );
  }
}