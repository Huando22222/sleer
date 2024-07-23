class Post {
  final String id;
  final Owner owner;
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
      owner: Owner.fromJson(json["owner"]),
      content: json["content"],
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

class Owner {
  final String id;
  final String displayName;
  final String avatar;
  final String phone;
  final DateTime createdAt;

  Owner({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.phone,
    required this.createdAt,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json["_id"],
      displayName: json["displayName"],
      avatar: json["avatar"],
      phone: json["phone"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'displayName': displayName,
      'avatar': avatar,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
