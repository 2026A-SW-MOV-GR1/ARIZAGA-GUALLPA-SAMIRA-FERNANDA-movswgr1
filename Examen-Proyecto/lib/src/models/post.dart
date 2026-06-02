class ApiPost {
  const ApiPost({
    required this.id,
    required this.title,
    required this.body,
    this.userId = 1,
  });

  final int id;
  final int userId;
  final String title;
  final String body;

  ApiPost copyWith({String? title, String? body}) {
    return ApiPost(
      id: id,
      userId: userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  factory ApiPost.fromJson(Map<String, dynamic> json) {
    return ApiPost(
      id: (json['id'] as num?)?.toInt() ?? 0,
      userId: (json['userId'] as num?)?.toInt() ?? 1,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'title': title, 'body': body};
  }
}
