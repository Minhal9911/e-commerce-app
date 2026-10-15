
import 'package:e_commerce_app/data/datasources/profile_local_datasource.dart';
import 'package:e_commerce_app/data/models/profile_model.dart';

class ProfileRepository {
  final ProfileLocalDatasource _localDatasource;

  ProfileRepository(this._localDatasource);

  Future<ProfileModel?> getProfile()async{
    return _localDatasource.getProfile();
  }

  Future<ProfileModel> updateProfile(ProfileModel profile)async{
    return _localDatasource.updateProfile(profile);
  }

}