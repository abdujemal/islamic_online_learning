import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BootstrapCacheService {
  static const _cacheKey = 'app_bootstrap_cache';
  static const _timestampKey = 'app_bootstrap_cache_time';

  Future<void> save(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(data));
    await prefs.setInt(
      _timestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_cacheKey);
    if (json == null) return null;
    return jsonDecode(json);
  }

  Future<bool> isFresh({Duration maxAge = const Duration(minutes: 5)}) async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_timestampKey);
    if (ts == null) return false;
    return DateTime.now()
        .difference(DateTime.fromMillisecondsSinceEpoch(ts)) < maxAge;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_timestampKey);
  }
}
