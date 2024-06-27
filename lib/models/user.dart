class User {
  final String id;
  final String displayName;
  final String avatar;
  final List<User> friends;
  final String refreshToken;
  final List<String> rooms;
  final String phone;
  final DateTime createdAt;

  User({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.friends,
    required this.refreshToken,
    required this.rooms,
    required this.phone,
    required this.createdAt,
  });

  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     id: json["_id"],
  //     displayName: json["displayName"] ?? '',
  //     avatar: json["avatar"] ?? 'default-avatar.svg',
  //     friends: (json['friends'] as List<dynamic>?)
  //             ?.map((userJson) => User.fromJson(userJson))
  //             .toList() ??
  //         [],
  //     refreshToken: json["refreshToken"],
  //     rooms: List<String>.from(json["rooms"] ?? []),
  //     phone: json["phone"],
  //     createdAt: DateTime.parse(json['createdAt']),
  //   );
  // }
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["_id"],
      displayName: json["displayName"],
      avatar: json["avatar"],
      friends: List<User>.from(
          (json['friends'] as List).map((userJson) => User.fromJson(userJson))),
      refreshToken: json["refreshToken"],
      rooms: List<String>.from(json["rooms"]),
      phone: json["phone"],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'displayName': displayName.isNotEmpty ? displayName : "",
      'avatar': avatar,
      'friends': friends.isNotEmpty
          ? friends.map((friend) => friend.toJson()).toList()
          : [],
      'refreshToken': refreshToken,
      'rooms': rooms.isNotEmpty ? rooms : [],
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'displayName': displayName.isNotEmpty ? displayName : "",
  //     'avatar': avatar,
  //     'friends': friends.isNotEmpty
  //         ? friends.map((friend) => friend.toJson()).toList()
  //         : [],
  //     'refreshToken': refreshToken,
  //     'rooms': rooms.isNotEmpty ? rooms : [],
  //     'phone': phone,
  //     'createdAt': createdAt.toIso8601String(),
  //   };
  // }
}
