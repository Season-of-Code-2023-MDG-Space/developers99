import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences{
  static SharedPreferences? _preferences;

  PreferencesProvider() {
    SharedPreferences.getInstance().then((prefs) => _preferences = prefs);
  }
  
  static const String _WishList = "";

  static const _UserName = 'Username';
  static const _Password = 'Password';
  static const _Email = 'Email';

  static const String _StockList = "";
  static const String _PriceList = "";
  static const String _StockVolList = "";

  static const String _Balance1 = "";
  static const String _Balance2 = "";

  static const String _StockName = "HINDALCO.NS";
  static const String _StockNameLong = "HINDALCO";

  static Future init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserName(String username) async => _preferences!.setString(_UserName, username);
  static getUserName() => _preferences!.get(_UserName);

  static Future setBalance1(double balance) async => _preferences!.setDouble(_Balance1, balance);
  static getBalance1() => _preferences!.get(_Balance1);

  static Future setBalance2(double balance) async => _preferences!.setDouble(_Balance2, balance);
  static getBalance2() => _preferences!.get(_Balance2);

  static Future setPassword(String password) async => _preferences!.setString(_UserName, password);
  static getPassword() => _preferences!.get(_Password);

  static Future setEmail(String email) async => _preferences!.setString(_Email, email);
  static getEmail() => _preferences!.get(_Email);

  static Future setStockName(String stockname) async => _preferences!.setString(_StockName, stockname);
  static getStockName() => _preferences!.get(_StockName);

  static Future setStockNameLong(String stocknamelong) async => _preferences!.setString(_StockNameLong, stocknamelong);
  static getStockNameLong() => _preferences!.get(_StockNameLong);

  static Future setWishList(List<String> wishlist) async => _preferences!.setStringList(_WishList, wishlist);
  static getWishList() => _preferences!.getStringList(_WishList);

  static Future setStockList(List<String> stocklist) async => _preferences!.setStringList(_StockList, stocklist);
  static getStockList() => _preferences!.getStringList(_StockList);

  static Future setPriceList(List<String> pricelist) async => _preferences!.setStringList(_PriceList, pricelist);
  static getPriceList() => _preferences!.getStringList(_PriceList);

  static Future setStockVolList(List<String> stockvollist) async => _preferences!.setStringList(_StockVolList, stockvollist);
  static getStockVolList() => _preferences!.getStringList(_StockVolList);
}