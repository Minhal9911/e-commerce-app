
import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable{
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    bool clearProfileImage = false,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage:clearProfileImage? null: profileImage ?? this.profileImage,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone, profileImage];

}