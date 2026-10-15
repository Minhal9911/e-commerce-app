import 'package:e_commerce_app/core/constants/storage_keys.dart';
import 'package:e_commerce_app/core/theme/theme_keys.dart';
import 'package:e_commerce_app/data/models/user_model_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _box;
  StorageService(this._box);


  //Token saved--------------------------------------------------------------------
  Future<void> setToken(String token)async{
  await _box.write(StorageKeys.token, token);
    debugPrint('Token saved: $token');
  }

  String getToken(){
    return _box.read(StorageKeys.token) ?? '';
  }

  //Login saved--------------------------------------------------------------------
  Future<void> setLogin(bool value) async{
  await _box.write(StorageKeys.loginKey, value);
    debugPrint('Login status saved: $value');
  }

  bool getLogin() {
    var isLoggedIn = _box.read(StorageKeys.loginKey);
    debugPrint('Login status retrieved: $isLoggedIn');
    return isLoggedIn ?? false;
  }

  //Saved user info----------------------------------------------------------------
  Future<void> saveUser(UserModel user)async{
    await _box.write(StorageKeys.userKey, user.toJson());
  }

  UserModel? getUser(){
    final data = _box.read(StorageKeys.userKey);
    if(data == null)return null;
    return UserModel.fromJson(Map<String,dynamic>.from(data));
  }

  //Theme mode saved---------------------------------------------------------------
  Future<void> setDarkMode(bool value)async{
   await _box.write(ThemeKeys.themeMode, value);
  }

  //true means dark mode, false means light mode
  bool getDarkMode(){
    return _box.read(ThemeKeys.themeMode) ?? false;
  }

  Future<void> logout()async{
    await _box.remove(StorageKeys.token);
    await _box.remove(StorageKeys.loginKey);
    await _box.remove(StorageKeys.userKey);
  }
}