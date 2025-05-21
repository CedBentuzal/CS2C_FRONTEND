import 'package:shared_preferences/shared_preferences.dart';

class RecentActivityService {
  static const String _key = 'recent_activity_product_ids';
  static const int maxRecent = 10;

  /// Add a product ID to recent activity
  static Future<void> addProductToRecent(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = prefs.getStringList(_key) ?? [];
    ids.remove(productId); // Remove if already exists to avoid duplicates
    ids.insert(0, productId); // Add to the front
    if (ids.length > maxRecent) ids = ids.sublist(0, maxRecent);
    await prefs.setStringList(_key, ids);
  }

  /// Get the list of recent product IDs
  static Future<List<String>> getRecentProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
}