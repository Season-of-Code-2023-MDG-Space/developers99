import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Services/ApiService.dart';
import 'search.dart';
import 'Services/LocalStorage.dart';
import 'dart:async';

Timer? timer;

late List<ChartData> _chartData;
List<Stonks>? StockIntra;
late int length;
String _StockName = "HINDALCO.NS";
int nsel = 1;
String _interval = "1m";

void SetStockName(String stockname){
  _StockName = stockname;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   StockIntra = await FetchSeries(name:_StockName);
   length = StockIntra!.length;
   await UserSharedPreferences.init();
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
late ZoomMode _zoomModeType;

class BottomSelectionWidget extends StatefulWidget {
  const BottomSelectionWidget({super.key});

  @override
  State<BottomSelectionWidget> createState() => _BottomSelectionWidgetState();
}

class _BottomSelectionWidgetState extends State<BottomSelectionWidget> {
  @override
  void initState(){
    _zoomModeType = ZoomMode.x;
    _zoomPanBehavior = ZoomPanBehavior(
        zoomMode: _zoomModeType,
        enableMouseWheelZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true
    );
    Future.delayed(Duration.zero,() async {
      StockIntra = await FetchSeries(name:_StockName);
    });
    length = StockIntra!.length;
    _chartData = getChartData();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => ChangeVar(interv: _interval));
    super.initState();
  }
  @override
  void ChangeVar({required String interv})async
  {
    setState((){
      Future.delayed(Duration.zero,() async {
        StockIntra = await FetchSeries(name:_StockName , interval: interv);
      });
      length = StockIntra!.length;
      getChartData();
      _chartData = getChartData();
    });
  }

  // @override
  // void ChangeVar1({required String symb})async
  // {
  //   StockIntra = await FetchSeriesDaily(searchterm: symb);
  //   setState((){
  //     length = StockIntra!.length;
  //     getChartData1();
  //     _chartData = getChartData1();
  //   });
  // }
  //
  // @override
  // void ChangeVar2({required String symb})async
  // {
  //   StockIntra = await FetchSeriesWeekly(searchterm: symb);
  //   setState((){
  //     length = StockIntra!.length;
  //     getChartData1();
  //     _chartData = getChartData1();
  //   });
  // }

  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$_StockName'),
        ),
        body: Column(children :[Container(
          height: 400,
          child:SfCartesianChart(series: <CandleSeries>[
            CandleSeries<ChartData, DateTime>(
                dataSource: _chartData,
                xValueMapper: (ChartData sales, _) => sales.x,
                lowValueMapper: (ChartData sales, _) => sales.low,
                highValueMapper: (ChartData sales, _) => sales.high,
                openValueMapper: (ChartData sales, _) => sales.open,
                closeValueMapper: (ChartData sales, _) => sales.close)
          ], primaryXAxis: DateTimeAxis(),
              zoomPanBehavior: _zoomPanBehavior,
            tooltipBehavior: TooltipBehavior(enable: true)),
          ),
          Row(children: [
            Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "1m");
                      _interval = "1m";
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
                      ChangeVar(interv: "5m");
                      _interval = "5m";
                  },
                  child: Text("5min"),
                )
            ),Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "15m");
                      _interval = "15m";
                  },
                  child: Text("15min"),
                )
            ),Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "30m");
                      _interval = "30m";
                  },
                  child: Text("30min"),
                )
            ),Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                      ChangeVar(interv: "60m");
                      _interval = "60m";
                  },
                  child: Text("60min"),
                )
            )]),
            Row(children: [Container(
                height: 30,
                margin:EdgeInsets.all(10),
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onPressed: (){
                    ChangeVar(interv: "1d");
                    _interval = "1d";
                  },
                  child: Text("1 Day"),
                )
            ),
              Container(
                  height: 30,
                  margin:EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: (){
                      ChangeVar(interv: "1wk");
                      _interval = "1wk";
                    },
                    child: Text("1 week"),
                  )
              ),
              Container(
                  height: 30,
                  margin:EdgeInsets.all(10),
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: (){
                      ChangeVar(interv: "1mo");
                      _interval = "1mo";
                    },
                    child: Text("1month"),
                  )
              ),
              ],),
            // Padding(
            //     padding: EdgeInsets.only(left: 10, top: 2),
            //     child: Text('Date+Time' + "               " + "Value",
            //         style: TextStyle(fontSize: 20, color: Colors.red))),
          // Expanded(
          //     child: Container(
          //         padding: EdgeInsets.only(left: 120),
          //         child: ListView.builder(
          //             padding: const EdgeInsets.only(top: 5),
          //             itemCount: length,
          //             itemBuilder: (BuildContext context, int index) {
          //               return Container(
          //                 height: 50,
          //                 child: Container(
          //                     child: Text(
          //                         StockIntra![index].Date_Time!.toString() +
          //                             "        " +
          //                             StockIntra![index].open.toString(),
          //                         style: TextStyle(fontSize: 15))),
          //               );
          //             }))),
          //Floating Action button
          Row(children: [FloatingActionButton(child:Icon(Icons.search),
              onPressed: (){Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen(),)
            );}),
          FloatingActionButton(child:Icon(Icons.minimize),
          onPressed:() {_zoomPanBehavior.reset();}
          )]),
        ]));
    }
  List<ChartData> getChartData() {
    return <ChartData>[
      for (int i = 0; i < length; i++)
        ChartData(
          x: StockIntra![i].Date_Time,
          open: StockIntra![i].open,
          close: StockIntra![i].close,
          low: StockIntra![i].low,
          high: StockIntra![i].high,
        )
    ];
  }
  List<ChartData> getChartData1() {
    return <ChartData>[
      for (int i = 0; i < length; i++)
        ChartData(
          x: StockIntra![i].Date_Time,
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


