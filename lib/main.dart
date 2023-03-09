import 'package:flutter/material.dart';
import 'Services/ApiService.dart';
import 'Services/LocalStorage.dart';
import 'Presentation/graph.dart';

String _StockName = UserSharedPreferences.getStockName();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   StockIntra = await FetchSeries(name:_StockName);
   length = StockIntra!.length;
   await UserSharedPreferences.init();
   runApp(const graphapp());
}