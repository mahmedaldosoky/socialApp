class UserModel {
  String email;
  String username;
  String phone;
  String uid;
  String bio;
  String image;
  String cover;

  UserModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.phone,
    this.bio = "write your bio..",
    this.image =
        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png",
    this.cover =
        "https://i.pinimg.com/originals/9e/8d/74/9e8d747819250be17bff875604223894.jpg",
  });

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      uid: json['uid'].toString().trim(),
      phone: json['phone'],
      email: json['email'],
      bio: json['bio'],
      image: json['image'],
      cover: json['cover'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'phone': phone,
      'uid': uid.trim(),
      'bio': bio,
      'image': image,
      'cover': cover,
    };
  }
}
