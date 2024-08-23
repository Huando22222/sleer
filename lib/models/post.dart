import 'package:sleer/models/friend.dart';

class Post {
  final String id;
  final Friend owner;
  final String content;
  final String image;
  final int reaction;
  final DateTime createdAt;

  Post(
      {required this.id,
      required this.owner,
      required this.content,
      required this.image,
      required this.reaction,
      required this.createdAt});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["_id"],
      owner: Friend.fromJson(json["owner"]),
      content: json["content"] ?? '',
      image: json["image"],
      reaction: json["reaction"],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner': owner.toJson(),
      'content': content,
      'image': image,
      'reaction': reaction,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
