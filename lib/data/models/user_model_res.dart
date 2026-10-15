import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String image;
  final String token;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.image,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      image: json['image'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'image': image,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [id, username, email, image, token];
}
