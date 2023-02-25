import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BottomSelectionWidget(),
    );
  }
}
//API KEY = VTHIJHII6A4M4MSF
String stringResponse = "initial";
Map mapResponse = Map();
Map mapResponse1 = Map();
List listRespone = [];
List listDateswithtime = [];
late ZoomPanBehavior _zoomPanBehavior;

class BottomSelectionWidget extends StatefulWidget {
  const BottomSelectionWidget({super.key});

  @override
  State<BottomSelectionWidget> createState() => _BottomSelectionWidgetState();
}

class _BottomSelectionWidgetState extends State<BottomSelectionWidget> {
  Future apicall() async {
    http.Response response;
    response = await http.get(
        Uri.parse("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=1min&apikey=demo"));
    if(response.statusCode == 200)
      {
        setState(() {
          mapResponse = json.decode(response.body);
          mapResponse1 = mapResponse["Time Series (1min)"];
          listDateswithtime = mapResponse1.keys.toList();
        });
      }
    else
      {
        setState(() {
          listRespone = ['error'];
        });
      }
  }
  late List<ChartData> _chartData;
  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
        enableMouseWheelZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true
    );
    apicall();
    super.initState();
  }
  int i = 0;

  @override
  Widget build(BuildContext context)
  {
    _chartData = getChartData();
    return Scaffold(
      appBar: AppBar(
        title: Text(listDateswithtime[0].substring(0, 10)),
      ) ,
        body:
        Column(
          children: [
            SfCartesianChart(
              series: <CandleSeries>[
                CandleSeries<ChartData, DateTime>
                  (dataSource: _chartData,
                    xValueMapper: (ChartData sales, _) => sales.x,
                    lowValueMapper: (ChartData sales, _) => sales.low,
                    highValueMapper: (ChartData sales, _) => sales.high,
                    openValueMapper: (ChartData sales, _) => sales.open,
                    closeValueMapper: (ChartData sales, _) => sales.close)
              ],
              primaryXAxis: DateTimeAxis(),
              zoomPanBehavior: _zoomPanBehavior
            ),
          Row(
          children: [Padding(padding: EdgeInsets.only(left: 10, top: 2),
          child: Text('Time' + "               " + "Value", style: TextStyle(fontSize: 20, color: Colors.red)))]
        ),
          Expanded(child: Container(
            padding: EdgeInsets.only(left: 2),
          child: ListView.builder(padding: const EdgeInsets.only(top: 5),
          itemCount: listDateswithtime.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Container(child: Text(listDateswithtime[index].substring(10, 13) + "                 " + mapResponse1[listDateswithtime[index]]["1. open"],
                  style: TextStyle(fontSize: 15))),
                );
              }
            )
          )
          )
        ]
       )
    );
  }
  List<ChartData> getChartData()
  {
    return <ChartData>[
      for(int i = 0; i < listDateswithtime.length; i++)
          ChartData(x: DateTime(2023, 2, 24, int.parse(listDateswithtime[i].substring(10, 13)), int.parse(listDateswithtime[i].substring(14, 16))),
            open: double.parse(mapResponse1[listDateswithtime[i]]["1. open"]),
            close: double.parse(mapResponse1[listDateswithtime[i]]["4. close"]),
            low: double.parse(mapResponse1[listDateswithtime[i]]["3. low"]),
            high: double.parse(mapResponse1[listDateswithtime[i]]["2. high"]),
          ),
        //)
    ];
  }
}

class ChartData{
  ChartData({this.x,
  this.open,
  this.close,
  this.high,
  this.low});

  final DateTime? x;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
}


