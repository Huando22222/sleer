class Auth {
  final String id;
  final String phone;
  final String name;

  Auth({
    required this.id,
    required this.phone,
    required this.name,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        id: json['_id'],
        name: json['name'],
        phone: json['phone'],
      );
}
