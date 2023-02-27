import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{
  static SharedPreferences? _preferences;
  static const String _WishList = "";

  static const _UserName = 'Username';
  static const _Password = 'Password';

  static const String _StockList = "";
  static const String _PriceList = "";
  static const String _StockVolList = "";

  static Future init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserName(String username) async => _preferences!.setString(_UserName, username);
  static getUserName() => _preferences!.get(_UserName);

  static Future setPassword(String password) async => _preferences!.setString(_UserName, password);
  static getPassword() => _preferences!.get(_Password);

  static Future setWishList(List<String> wishlist) async => _preferences!.setStringList(_WishList, wishlist);
  static getWishList() => _preferences!.getStringList(_WishList);

  static Future setStockList(List<String> stocklist) async => _preferences!.setStringList(_StockList, stocklist);
  static getStockList() => _preferences!.getStringList(_StockList);

  static Future setPriceList(List<String> pricelist) async => _preferences!.setStringList(_PriceList, pricelist);
  static getPriceList() => _preferences!.getStringList(_PriceList);

  static Future setStockVolList(List<String> stockvollist) async => _preferences!.setStringList(_StockVolList, stockvollist);
  static getStockVolList() => _preferences!.getStringList(_StockVolList);
}