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
String _StockLongName = "Hindalco Industries Ltd";
int nsel = 1;
String _interval = "1m";

Color passivebgbuttoncolour = const Color(0xff000033);
Color activebgbuttoncolor = Color(0xff000063);
Color activetxtcolor = Colors.white;
Color passivetxtcolor = Colors.white60;

void SetStockName(String stockname, String stocklongname){
  _StockName = stockname;
  _StockLongName = stocklongname;
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
  CurrentStat CurrentPriceStatus = new CurrentStat();
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
      CurrentPriceStatus = await Currentstatus(name: _StockName);
    });
    length = StockIntra!.length;
    _chartData = getChartData();
    timer = Timer.periodic(Duration(seconds:2), (Timer t) => ChangeVar(interv: _interval));
    super.initState();
  }
  @override
  void ChangeVar({required String interv})async
  {
    setState((){
      Future.delayed(Duration(milliseconds: 200),() async {
        StockIntra = await FetchSeries(name:_StockName , interval: interv);
        CurrentPriceStatus = await Currentstatus(name: _StockName);
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
    return Scaffold(backgroundColor: Color(0xff000013),
        appBar: AppBar(backgroundColor: Colors.black,
          title: Row(children: [
            Container(
              height: 50,
              width: 50,
              child: FloatingActionButton(child:Icon(Icons.search),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.amberAccent,
                  onPressed: (){Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchScreen(),)
                  );})),

          Column(children:<Widget>[Container(child:
            Text('$_StockName',style:TextStyle(fontSize: 25, fontFamily: 'ConcertOne',),),
          padding: EdgeInsets.only(left: 80),),

          Container(padding: EdgeInsets.only(top: 10, left: 80),
              child:Text('$_StockLongName', style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.white54)))])]),
          centerTitle: true,
        ),
        body:
        Column(
            children :[
              Column(children: [
                Text("${CurrentPriceStatus.RegMarketPrice}", style: TextStyle(color: Colors.white, fontSize: 40),),
                Row(children: [Container(padding: EdgeInsets.only(left: 130),
                    child:Text("${CurrentPriceStatus.ChangeAmt}",
                      style: TextStyle(fontSize: 17, color: (CurrentPriceStatus.ChangeAmt! > 0)? Colors.green : Colors.red),)),
                  Text("  (${CurrentPriceStatus.ChangePer}%)", style: TextStyle(fontSize: 17,color: (CurrentPriceStatus.ChangePer! > 0)? Colors.green : Colors.red),)
          ],),]),
          Row(
              children: [
            Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                margin:EdgeInsets.all(1),
                child: FloatingActionButton(backgroundColor: bgbuttoncolor("1m"),
                  shape: RoundedRectangleBorder(),
                  onPressed: (){
                      ChangeVar(interv: "1m");
                      _interval = "1m";
                  },
                  child: Text("1min", style: TextStyle(color: txtbuttoncolor("1m")),
                )
            )),
            Container(
                height: 30,
                width: 40,
                margin:EdgeInsets.all(1),
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                child: FloatingActionButton(backgroundColor: bgbuttoncolor("5m"),
                  shape: RoundedRectangleBorder(),
                  onPressed: (){
                      ChangeVar(interv: "5m");
                      _interval = "5m";
                  },
                  child: Text("5min", style: TextStyle(color: txtbuttoncolor("5m")),),
                )
            ),Container(
                height: 30,
                width: 50,
                margin:EdgeInsets.all(1),
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                child: FloatingActionButton(backgroundColor: bgbuttoncolor("15m"),
                  shape: RoundedRectangleBorder(),
                  onPressed: (){
                      ChangeVar(interv: "15m");
                      _interval = "15m";
                  },
                  child: Text("15min", style: TextStyle(color: txtbuttoncolor("15m")),),
                )
            ),Container(
                height: 30,
                width: 50,
                margin:EdgeInsets.all(1),
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                child: FloatingActionButton(backgroundColor: bgbuttoncolor("30m"),
                  shape: RoundedRectangleBorder(),
                  onPressed: (){
                      ChangeVar(interv: "30m");
                      _interval = "30m";
                  },
                  child: Text("30min", style: TextStyle(color: txtbuttoncolor("30m")),),
                )
            ),Container(
                height: 30,
                width: 50,
                margin:EdgeInsets.all(1),
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                child: FloatingActionButton(backgroundColor: bgbuttoncolor("60m"),
                  shape: RoundedRectangleBorder(),
                  onPressed: (){
                      ChangeVar(interv: "60m");
                      _interval = "60m";
                  },
                  child: Text("60min", style: TextStyle(color: txtbuttoncolor("60m")),),
                )
            ),
                Container(
                height: 30,
                width: 50,
                margin:EdgeInsets.all(1),
                decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                child: FloatingActionButton(backgroundColor: bgbuttoncolor("1d"),
                  shape: RoundedRectangleBorder(),
                  onPressed: (){
                    ChangeVar(interv: "1d");
                    _interval = "1d";
                  },
                  child: Text("1 Day", style: TextStyle(color: txtbuttoncolor("1d")),),
                )
            ),
              Container(
                  height: 30,
                  width: 50,
                  margin:EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                  child: FloatingActionButton(backgroundColor: bgbuttoncolor("1wk"),
                    shape: RoundedRectangleBorder(),
                    onPressed: (){
                      ChangeVar(interv: "1wk");
                      _interval = "1wk";
                    },
                    child: Text("1week", style: TextStyle(color: txtbuttoncolor("1wk")),),
                  )
              ),
              Container(
                  height: 30,
                  width: 60,
                  margin:EdgeInsets.all(1),
                  child: FloatingActionButton(backgroundColor: bgbuttoncolor("1mo"),
                    shape: RoundedRectangleBorder(),
                    onPressed: (){
                      ChangeVar(interv: "1mo");
                      _interval = "1mo";
                    },
                    child: Text("1month", style: TextStyle(color: txtbuttoncolor("1mo")),),
                  )
              ),]),
              Container( color: Color(0xff000013),
                height: 400,
                child:SfCartesianChart(series: <CandleSeries>[
                  CandleSeries<ChartData, DateTime>(
                      bearColor: Colors.red.shade500,
                      bullColor: Colors.green.shade600,
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
          Row(children: [Container(
              height: 40,
              padding: EdgeInsets.only(left: 120),
              child:
            FloatingActionButton(child:Icon(Icons.zoom_in_map_sharp),
                backgroundColor: Colors.black,
                onPressed:() {_zoomPanBehavior.reset();}
            )),
            Container(
              height: 40,
                padding: EdgeInsets.only(left: 10),
                child:
            FloatingActionButton(child:Icon(Icons.zoom_in),
                backgroundColor: Colors.black,
                onPressed:() {_zoomPanBehavior.zoomIn();}
            )),
            Container(
              height: 40,
                padding: EdgeInsets.only(left: 10),
                child:
            FloatingActionButton(child:Icon(Icons.zoom_out),
                backgroundColor: Colors.black,
                onPressed:() {_zoomPanBehavior.zoomOut();}
            )),
            ]),
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

Color bgbuttoncolor(String inter)
{
  if(inter == _interval)
    {
      return(activebgbuttoncolor);
    }
  else
    {
      return(passivebgbuttoncolour);
    }
}

Color txtbuttoncolor(String inter)
{
  if(inter == _interval)
  {
    return(activetxtcolor);
  }
  else
  {
    return(passivetxtcolor);
  }
}