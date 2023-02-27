import 'package:http/http.dart' as http;
import 'dart:convert';
String ApiKey = "UTEZWDDLD1LLMY35";
class HttpRequestException implements Exception {
  final String message;

  HttpRequestException(this.message);
}

Future<List<Stonks>> FetchSeries({String interval = "1min", required String name}) async {
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$name&interval=$interval&apikey=$ApiKey"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    List <Stonks> Stocks = [];
      List <String> _temp = List<String>.of(
        (mapResponse["Time Series (${interval})"] as Map<String, dynamic>).keys);
      for(int i = 0; i < _temp.length; i++)
        {
          Stocks.add(Stonks(Date_Time:_temp[i],
              open: double.parse(mapResponse["Time Series (${interval})"]["${_temp[i]}"]["1. open"]),
              close: double.parse(mapResponse["Time Series (${interval})"]["${_temp[i]}"]["4. close"]),
              high: double.parse(mapResponse["Time Series (${interval})"]["${_temp[i]}"]["2. high"]),
              low: double.parse(mapResponse["Time Series (${interval})"]["${_temp[i]}"]["3. low"]),
              vol: double.parse(mapResponse["Time Series (${interval})"]["${_temp[i]}"]["5. volume"])));
        }
      return (Stocks);
  } else {
    throw HttpRequestException('Failed to load data');
  }
}

Future<List<Stonks>> FetchSeriesDaily({required String searchterm}) async { //To get daily history for 100 days
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=$searchterm&apikey=$ApiKey"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    List <Stonks> Stocks = [];
    List <String> _temp = List<String>.of(
        (mapResponse["Time Series (Daily)"] as Map<String, dynamic>).keys);
    for(int i = 0; i < _temp.length; i++)
    {
      Stocks.add(Stonks(Date_Time:_temp[i],
          open: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["1. open"]),
          close: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["4. close"]),
          high: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["2. high"]),
          low: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["3. low"]),
          vol: double.parse(mapResponse["Time Series (Daily)"]["${_temp[i]}"]["6. volume"])));
    }
    return (Stocks);
  } else {
    throw HttpRequestException('Failed to load data');
  }
}

Future<List<Stonks>> FetchSeriesWeekly({required String searchterm}) async { //To get weekly history
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=${searchterm}&apikey=${ApiKey}"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    List <Stonks> Stocks = [];
    List <String> _temp = List<String>.of(
        (mapResponse["Weekly Time Series"] as Map<String, dynamic>).keys);
    for(int i = 0; i < _temp.length; i++)
    {
      Stocks.add(Stonks(Date_Time:_temp[i],
          open: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["1. open"]),
          close: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["4. close"]),
          high: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["2. high"]),
          low: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["3. low"]),
          vol: double.parse(mapResponse["Weekly Time Series"]["${_temp[i]}"]["5. volume"])));
    }
    return (Stocks);
  } else {
    throw HttpRequestException('Failed to load data');
  }
}

Future<List<Stonks>> FetchSeriesMonthly({required String searchterm}) async { //To get monthly history for 100 days
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=${searchterm}&apikey=${ApiKey}"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    List <Stonks> Stocks = [];
    List <String> _temp = List<String>.of(
        (mapResponse["Monthly Time Series"] as Map<String, dynamic>).keys);
    for(int i = 0; i < _temp.length; i++)
    {
      Stocks.add(Stonks(Date_Time:_temp[i],
          open: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["1. open"]),
          close: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["4. close"]),
          high: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["2. high"]),
          low: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["3. low"]),
          vol: double.parse(mapResponse["Monthly Time Series"]["${_temp[i]}"]["5. volume"])));
    }
    return (Stocks);
  } else {
    throw HttpRequestException('Failed to load data');
  }
}

Future<List<Result>> Search({required String searchterm}) async {
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=${searchterm}&apikey=${ApiKey}"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    List temp = mapResponse["bestMatches"];
    List<Result> Results = [];
    for (int i = 0; i < temp.length; i++)
      {
        Results.add(Result(Symbol: temp[i]["1. symbol"], Name: temp[i]["2. name"]));
      }
    return (Results);
  } else {
    throw HttpRequestException('Failed to load data');
  }
}

class Stonks{
  Stonks({this.Date_Time,
    this.open,
    this.close,
    this.high,
    this.low,
    this.vol});

  final String? Date_Time;
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