import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _key = 'saved_number_info';

  /// Сохраняет новую строку информации, добавляя к списку
  static Future<void> saveInfo(String info) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = prefs.getStringList(_key) ?? [];


    if (!currentList.contains(info)) {
      currentList.add(info);
      await prefs.setStringList(_key, currentList);
    }
  }

  /// Получает сохранённые данные
  static Future<List<String>> getSavedInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Очистка всех сохранённых данных (по желанию)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
