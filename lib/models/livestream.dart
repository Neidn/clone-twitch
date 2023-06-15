import 'dart:convert';

class LiveStream {
  final String title;
  final String uid;
  final String image;
  final String username;
  final DateTime startedAt;
  final int viewers;
  final String channelId;

  LiveStream({
    required this.title,
    required this.uid,
    required this.image,
    required this.username,
    required this.startedAt,
    required this.viewers,
    required this.channelId,
  });

  factory LiveStream.fromMap(Map<String, dynamic> map) => LiveStream(
        title: map['title'] ?? '',
        uid: map['uid'] ?? '',
        image: map['image'] ?? '',
        username: map['username'] ?? '',
        startedAt: map['startedAt'] ?? DateTime.now(),
        viewers: map['viewers']?.toInt() ?? 0,
        channelId: map['channelId'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'uid': uid,
        'image': image,
        'username': username,
        'startedAt': startedAt,
        'viewers': viewers,
        'channelId': channelId,
      };

  factory LiveStream.fromJson(String source) =>
      LiveStream.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
