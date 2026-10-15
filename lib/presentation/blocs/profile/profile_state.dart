import 'package:e_commerce_app/data/models/profile_model.dart';
import 'package:equatable/equatable.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState{
  final ProfileModel profile;

  const ProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

final class ProfileEmpty extends ProfileState{
  const ProfileEmpty();
}

final class ProfileError extends ProfileState{
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}