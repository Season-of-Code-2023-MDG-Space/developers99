import 'package:http/http.dart' as http;
import 'dart:convert';
String ApiKey = "UTEZWDDLD1LLMY35";
class HttpRequestException implements Exception {
  final String message;

  HttpRequestException(this.message);
}

Future<List<String>> fetchSeriesDateDT({String interval = "1min"}) async {
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=${interval}&apikey=${ApiKey}"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    return List<String>.of(
        (mapResponse["Time Series (${interval})"] as Map<String, dynamic>).keys);
  } else {
    throw HttpRequestException('Failed to load data');
  }
}

Future<Map> fetchSeriesDateValues({String interval = "1min"}) async {
  final response = await http.get(Uri.parse(
      "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=${interval}&apikey=${ApiKey}"));
  if (response.statusCode == 200) {
    final mapResponse = json.decode(response.body);
    return (mapResponse["Time Series (${interval})"]);
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