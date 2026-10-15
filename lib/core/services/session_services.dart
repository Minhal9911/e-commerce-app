import 'package:e_commerce_app/core/services/storage_service.dart';
import 'package:e_commerce_app/data/models/user_model_res.dart';
import 'package:flutter/cupertino.dart';

class SessionServices {
  final StorageService storage;

  SessionServices(this.storage);

  bool get isLoggedIn => storage.getLogin();

  String get token => storage.getToken();

  UserModel? get currentUser => storage.getUser();

  /* bool isLoggedIn() {
    final loggedIn = storage.getLogin();
    debugPrint('Checking login status, token: $loggedIn');
    return loggedIn;
  }*/

  Future<void> saveSession(UserModel user) async {
    await storage.saveUser(user);
    await storage.setToken(user.token);
    debugPrint("Session saved with token: ${user.token}");
    await storage.setLogin(true);
  }

  Future<void> clearSession() async {
    await storage.logout();
  }
}
