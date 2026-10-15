import 'package:e_commerce_app/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileEvent extends Equatable{
  const ProfileEvent();
  @override
  List<Object?> get props =>[];
}

final class LoadProfile extends ProfileEvent{
  const LoadProfile();
}

final class UpdateProfile extends ProfileEvent{
  final ProfileModel profile;
  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

final class RemoveProfileImage extends ProfileEvent{
  const RemoveProfileImage();
}