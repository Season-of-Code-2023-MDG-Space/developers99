import 'package:http/http.dart' as http;
import 'dart:convert';
String ApiKey = "UTEZWDDLD1LLMY35";
class HttpRequestException implements Exception {
  final String message;

  HttpRequestException(this.message);
}

Future<List<Stonks>> FetchSeries({String interval = "1min"}) async {
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=${interval}&apikey=${ApiKey}"));
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
    print('Failed to load data');
    throw HttpRequestException('Failed to load data');
  }
}

Future<Map> Search({required String searchterm}) async {
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=${searchterm}&apikey=${ApiKey}"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    return (mapResponse["Time Series (${searchterm})"]);
    //key is the date and time for which you want data
    //All keys are presents in fetchOneMinuteSeriesDateDT()
    //Access opening data using following methods
    //_map = fetchOneMinuteSeriesDate()
    //to get opening value use _map[key]["1. open"]
    //_map[key]["2. high"] for high
    //_map[key]["3. low"] for low
    //_map[key]["4. close"] for closing
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