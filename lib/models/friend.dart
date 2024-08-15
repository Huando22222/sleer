class Friend {
  final String id;
  final String displayName;
  final String avatar;
  final String phone;

  Friend({
    required this.id,
    required this.displayName,
    required this.avatar,
    required this.phone,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['_id'],
      displayName: json['displayName'] ?? '',
      avatar: json['avatar'] ?? 'default-avatar.svg',
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'avatar': avatar,
      'phone': phone,
    };
  }
}
