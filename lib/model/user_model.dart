class UserModel {
  final String uid;
  final String name;
  final String username;
  final String email;
  final String? imageUrl;
  final bool isOnline;
  final String createdAt;
  final DateTime? lastSeen;

  UserModel({
    required this.uid,
    required this.name,
    required this.username,
    required this.email,
    this.imageUrl,
    required this.isOnline,
    required this.createdAt,
    this.lastSeen,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "username": username,
    "email": email,
    "imageUrl": imageUrl,
    "isOnline": isOnline,
    "createdAt": createdAt,
    "lastSeen": lastSeen,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? "",
      name: json['name'] ?? "",
      username:
          json['username'] ??
          (json['name'] != null
              ? json['name'].toString().toLowerCase().replaceAll(' ', '')
              : ""),
      email: json['email'] ?? "",
      imageUrl: json['imageUrl'] ?? "",
      isOnline: json['isOnline'] ?? false,
      createdAt: json['createdAt'] ?? "",
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'])
          : null,
    );
  }
}
