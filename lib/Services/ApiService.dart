import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

// String ApiKey = "UTEZWDDLD1LLMY35";
// class HttpRequestException implements Exception {
//   final String message;
//
//   HttpRequestException(this.message);
// }

Future<List<Stonks>> FetchSeries({String interval = "1m", required String name}) async {
  final response = await http.get(Uri.parse(
      "https://query1.finance.yahoo.com/v8/finance/chart/$name?interval=$interval&includePrePost=true&period2=${(DateTime.now().microsecondsSinceEpoch ~/ pow(10, 6)) + 6000}&useYfid=true"));
    final mapResponse = json.decode(response.body);
    List <Stonks> Stocks = [];
    List <dynamic> _temp = mapResponse["chart"]["result"][0]["timestamp"];
      for(int i = 0; i < _temp.length; i++)
        {
          Stocks.add(Stonks(Date_Time:DateTime.fromMillisecondsSinceEpoch(_temp[i] * 1000),
              open: mapResponse["chart"]["result"][0]["indicators"]["quote"][0]["open"][i],
              close: mapResponse["chart"]["result"][0]["indicators"]["quote"][0]["close"][i],
              high: mapResponse["chart"]["result"][0]["indicators"]["quote"][0]["high"][i],
              low: mapResponse["chart"]["result"][0]["indicators"]["quote"][0]["low"][i],
              vol: mapResponse["chart"]["result"][0]["indicators"]["quote"][0]["volume"][i]));
        }
      return (Stocks);
}

Future<CurrentStat> Currentstatus({required String name}) async {
  final response = await http.get(Uri.parse(
      "https://query1.finance.yahoo.com/v7/finance/quote?formatted=true&symbols=$name"));
  final mapResponse = json.decode(response.body);
  CurrentStat temp = new CurrentStat();
  temp.RegMarketPrice = mapResponse["quoteResponse"]["result"][0]["regularMarketPrice"]["raw"];
  temp.ChangeAmt = mapResponse["quoteResponse"]["result"][0]["regularMarketChange"]["raw"];
  temp.ChangePer = mapResponse["quoteResponse"]["result"][0]["regularMarketChangePercent"]["raw"];
  return (temp);
}

// Future<List<Stonks>> FetchSeriesDaily({required String searchterm}) async { //To get daily history for 100 days
//   final response = await http.get(Uri.parse(
//       "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$searchterm&apikey=$ApiKey"));
//   if (response.statusCode == 200) {
//     final mapResponse = json.decode(response.body);
//     List <Stonks> Stocks = [];
//     List <String> _temp = List<String>.of(
//         (mapResponse["Time Series (Daily)"] as Map<String, dynamic>).keys);
//     for(int i = 0; i < _temp.length; i++)
//     {
//       Stocks.add(Stonks(Date_Time:_temp[i],
//           open: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["1. open"]),
//           close: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["4. close"]),
//           high: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["2. high"]),
//           low: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["3. low"]),
//           vol: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["6. volume"])));
//     }
//     return (Stocks);
//   } else {
//     throw HttpRequestException('Failed to load data');
//   }
// }
//
// Future<List<Stonks>> FetchSeriesWeekly({required String searchterm}) async { //To get weekly history
//   final response = await http.get(Uri.parse(
//       "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=${searchterm}&apikey=${ApiKey}"));
//   if (response.statusCode == 200) {
//     final mapResponse = json.decode(response.body);
//     List <Stonks> Stocks = [];
//     List <String> _temp = List<String>.of(
//         (mapResponse["Weekly Time Series"] as Map<String, dynamic>).keys);
//     for(int i = 0; i < _temp.length; i++)
//     {
//       Stocks.add(Stonks(Date_Time:_temp[i],
//           open: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["1. open"]),
//           close: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["4. close"]),
//           high: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["2. high"]),
//           low: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["3. low"]),
//           vol: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["5. volume"])));
//     }
//     return (Stocks);
//   } else {
//     throw HttpRequestException('Failed to load data');
//   }
// }
//
// Future<List<Stonks>> FetchSeriesMonthly({required String searchterm}) async { //To get monthly history for 100 days
//   final response = await http.get(Uri.parse(
//       "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=${searchterm}&apikey=${ApiKey}"));
//   if (response.statusCode == 200) {
//     final mapResponse = json.decode(response.body);
//     List <Stonks> Stocks = [];
//     List <String> _temp = List<String>.of(
//         (mapResponse["Monthly Time Series"] as Map<String, dynamic>).keys);
//     for(int i = 0; i < _temp.length; i++)
//     {
//       Stocks.add(Stonks(Date_Time:_temp[i],
//           open: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["1. open"]),
//           close: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["4. close"]),
//           high: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["2. high"]),
//           low: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["3. low"]),
//           vol: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["5. volume"])));
//     }
//     return (Stocks);
//   } else {
//     throw HttpRequestException('Failed to load data');
//   }
// }
//
Future<List<Result>> Search({required String searchterm}) async {
  final response = await http.get(Uri.parse(
      "https://query1.finance.yahoo.com/v1/finance/search?q=$searchterm"));
    final mapResponse = json.decode(response.body);
    List temp = mapResponse["quotes"];
    List<Result> Results = [];
    for (int i = 0; i < temp.length; i++)
      {
        if(temp[i]["longname"] != null){
          Results.add(Result(Symbol: temp[i]["symbol"], Name: temp[i]["longname"]));}
        else{
          Results.add(Result(Symbol: temp[i]["symbol"], Name: temp[i]["shortname"]));}
      }
    return (Results);
  }

class Stonks{
  Stonks({this.Date_Time,
    this.open,
    this.close,
    this.high,
    this.low,
    this.vol});

  final DateTime? Date_Time;
  num? open;
  num? close;
  num? low;
  num? high;
  num? vol;
}

class Result{
  Result({this.Symbol, this.Name});
  String? Symbol;
  String? Name;
}

class CurrentStat{
  CurrentStat({this.RegMarketPrice, this.ChangePer, this.ChangeAmt});
  double? RegMarketPrice;
  double? ChangePer;
  double? ChangeAmt;
}
