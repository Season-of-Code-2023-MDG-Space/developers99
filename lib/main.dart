import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Services/ApiService.dart';
import 'search.dart';

late List<ChartData> _chartData;
List<Stonks>? StockIntra;
late int length;

void main() async {
  StockIntra = await FetchSeries();
  length = StockIntra!.length;
  print(length);
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

late ZoomPanBehavior _zoomPanBehavior;

class BottomSelectionWidget extends StatefulWidget {
  const BottomSelectionWidget({super.key});

  @override
  State<BottomSelectionWidget> createState() => _BottomSelectionWidgetState();
}

class _BottomSelectionWidgetState extends State<BottomSelectionWidget> {
  @override
  void initState(){
    _zoomPanBehavior = ZoomPanBehavior(
        enableMouseWheelZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true
    );
    Future.delayed(Duration.zero,() async {
      StockIntra = await FetchSeries();
    });
    length = StockIntra!.length;
    super.initState();
  }
  @override
  void ChangeVar({required String interv})async
  {
    StockIntra = await FetchSeries(interval: interv);
    setState((){
      length = StockIntra!.length;
      getChartData();
    });
  }

  int i = 0;

  @override
  Widget build(BuildContext context) {
    _chartData = getChartData();
    return Scaffold(
        appBar: AppBar(
          title: Text(StockIntra![0].Date_Time!.substring(0, 10)),
        ),
        body: Column(children: [
          SfCartesianChart(series: <CandleSeries>[
            CandleSeries<ChartData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartData sales, _) => sales.x,
                lowValueMapper: (ChartData sales, _) => sales.low,
                highValueMapper: (ChartData sales, _) => sales.high,
                openValueMapper: (ChartData sales, _) => sales.open,
                closeValueMapper: (ChartData sales, _) => sales.close)
          ], primaryXAxis: DateTimeAxis(),
              zoomPanBehavior: _zoomPanBehavior,
            tooltipBehavior: TooltipBehavior(enable: true),
          ),
          Row(children: [
            Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "1min");
                  },
                  child: Text("1min"),
                )
            ),
            Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "5min");
                  },
                  child: Text("5min"),
                )
            ),Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "15min");
                  },
                  child: Text("15min"),
                )
            ),Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "30min");
                  },
                  child: Text("30min"),
                )
            ),Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "60min");
                  },
                  child: Text("60min"),
                )
            )]),
            Padding(
                padding: EdgeInsets.only(left: 10, top: 2),
                child: Text('Time' + "               " + "Value",
                    style: TextStyle(fontSize: 20, color: Colors.red))),
          Expanded(
              child: Container(
                  padding: EdgeInsets.only(left: 2),
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 5),
                      itemCount: length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 50,
                          child: Container(
                              child: Text(
                                  StockIntra![index].Date_Time!.substring(11,) +
                                      "                 " +
                                      StockIntra![index].open.toString(),
                                  style: TextStyle(fontSize: 15))),
                        );
                      }))),
          //Floating Action button
          FloatingActionButton(onPressed: (){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen())
            );})
        ]),
    );
    }
  List<ChartData> getChartData() {
    return <ChartData>[
      for (int i = 0; i < length; i++)
        ChartData(
          x: DateTime(
              int.parse(StockIntra![i].Date_Time!.substring(0,4)),
              int.parse(StockIntra![i].Date_Time!.substring(5,7)),
              int.parse(StockIntra![i].Date_Time!.substring(8,10)),
              int.parse(StockIntra![i].Date_Time!.substring(10, 13)),
              int.parse(StockIntra![i].Date_Time!.substring(14, 16))),
          open: StockIntra![i].open,
          close: StockIntra![i].close,
          low: StockIntra![i].low,
          high: StockIntra![i].high,
        )
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


