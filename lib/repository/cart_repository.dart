import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  static const String _cartKey = 'cart';

  Future<List<String>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_cartKey) ?? [];
  }

  Future<void> addToCart(String ref) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCartItems();
    cart.add(ref);
    prefs.setStringList(_cartKey, cart);
  }

  Future<void> removeFromCart(String ref) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCartItems();
    cart.remove(ref);
    prefs.setStringList(_cartKey, cart);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_cartKey);
  }
}
