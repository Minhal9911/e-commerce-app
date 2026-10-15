import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/data/models/profile_model.dart';
import 'package:get_storage/get_storage.dart';

class ProfileLocalDatasource {
  final GetStorage _storage;

  ProfileLocalDatasource(this._storage);

  Future<ProfileModel?> getProfile()async{
    final data = _storage.read<Map<String,dynamic>>(StorageKeys.profileKey);
    if(data ==null){
      return null;
    }
    return ProfileModel(id: data['id'], name: data['name'], email: data['email'], phone: data['phone'],profileImage: data['profileImage']);
  }

  Future<ProfileModel> updateProfile(ProfileModel profile)async{
    final data = <String,dynamic>{
      'id': profile.id,
      'name': profile.name,
      'email': profile.email,
      'phone': profile.phone,
      'profileImage': profile.profileImage,
    };
    await _storage.write(StorageKeys.profileKey, data);
    return profile;
  }

}