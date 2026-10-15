import 'package:e_commerce_app/core/services/storage_service.dart';

class ThemeRepository {
  final StorageService storage;

  ThemeRepository(this.storage);

  bool getTheme() {
    return storage.getDarkMode();
  }

  Future<void> saveTheme(bool isDark) async {
    await storage.setDarkMode(isDark);
  }
}
