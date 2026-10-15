import 'package:e_commerce_app/core/errors/error_mapper.dart';
import 'package:e_commerce_app/data/repositories/profile_repository.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_event.dart';
import 'package:e_commerce_app/presentation/blocs/profile/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repo;

  ProfileBloc(this._repo) : super(const ProfileInitial()){
    on<LoadProfile>(_loadProfile);
    on<UpdateProfile>(_updateProfile);
    on<RemoveProfileImage>(_removeProfileImage);
  }

  Future<void> _loadProfile(LoadProfile event, Emitter<ProfileState> emit)async{
    emit(const ProfileLoading());
    try{
      final profile = await _repo.getProfile();
      if(profile == null){
        emit(const ProfileEmpty());
        return;
      }
      emit(ProfileLoaded(profile));
    }catch(e){
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _updateProfile(UpdateProfile event, Emitter<ProfileState> emit)async{
    final previousState = state;
    emit(const ProfileLoading());
    try{
      final updatedProfile = await _repo.updateProfile(event.profile);
      emit(ProfileLoaded(updatedProfile));

    }catch(e){
      if(previousState is ProfileLoaded){
        emit(previousState);

      }else{
        ProfileError(ErrorMapper.map(e));
      }
    }
  }

  Future<void> _removeProfileImage(RemoveProfileImage event, Emitter<ProfileState> emit)async{
    if(state is! ProfileLoaded){
      return;
    }
    final currentProfile = (state as ProfileLoaded).profile;

    final updatedProfile = currentProfile.copyWith(clearProfileImage: true);

    add(UpdateProfile(updatedProfile));
  }
}