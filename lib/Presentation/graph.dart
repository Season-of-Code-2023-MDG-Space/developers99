import 'dart:async';
//import 'search.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '/Services/ApiService.dart';

Timer? timer;

class graphapp extends StatelessWidget {
  const graphapp({super.key});

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

  void SetStockName(String stockname, String stocklongname){
    _StockName = stockname;
    _StockLongName = stocklongname;
  }

  List<Stonks>? StockIntra;
  String _StockName = "AAPL";
  String _StockLongName = "APPLE INC.";
  int nsel = 1;
  String _interval = "1m";

  Color passivebgbuttoncolour = const Color(0xff000033);
  Color activebgbuttoncolor = Color(0xff000063);
  Color activetxtcolor = Colors.white;
  Color passivetxtcolor = Colors.white60;


  late int length;
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
    setState(() {
      Future.delayed(Duration.zero,() async {
        //StockIntra = await FetchSeries(name:_StockName);
      CurrentPriceStatus = await Currentstatus(name: _StockName);
      });
       //length = StockIntra!.length;
       //_chartData = getChartData(length: length, StockData: StockIntra!);
      timer = Timer.periodic(Duration(seconds:2), (Timer t) => ChangeVar(interv: _interval));
     });
    super.initState();
  }
  @override
  void ChangeVar({required String interv})async
  {
    setState((){
      Future.delayed(Duration(milliseconds: 200),() async {
        //StockIntra = await FetchSeries(name:_StockName , interval: interv);
        CurrentPriceStatus = await Currentstatus(name: _StockName);
      });
      //length = StockIntra!.length;
      //_chartData = getChartData(length: length,  StockData: StockIntra!);
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
              FutureBuilder<CurrentStat>(
                future: Currentstatus(name: _StockName),
                builder: (context, AsyncSnapshot<CurrentStat> snapshot){
                  if(snapshot.hasError){
                    return Center(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children:const [
                              Icon(Icons.error, color: Colors.red,size: 90,),
                            ]));
                  }
                  else if(snapshot.hasData)
                  {
                    CurrentStat _temp = snapshot.data!;
                    return(Column(children: [
                      Text("${_temp.RegMarketPrice}", style: TextStyle(color: Colors.white, fontSize: 40)
                      ),
                    Row(children: [Container(padding: EdgeInsets.only(left: 130),
                    child:Text("${_temp.ChangeAmt}",
                    style: TextStyle(fontSize: 17, color: (_temp.ChangeAmt! > 0)? Colors.green : Colors.red),)),
                    Text("  (${_temp.ChangePer}%)", style: TextStyle(fontSize: 17,color: (_temp.ChangePer! > 0)? Colors.green : Colors.red),),
                    ])]));
                  }
                  else
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
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
                child:FutureBuilder<SfCartesianChart>(
                  future: getGraph(symb: _StockName),
                  builder: (context, AsyncSnapshot<SfCartesianChart> snapshot){
                  if(snapshot.hasError){
                    return Center(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                    Icon(Icons.error, color: Colors.red,size: 90,),
                  ]));
                  }
                  else if(snapshot.hasData)
                  {
                  final result = snapshot.data!;
                    return (result);
                  }
                    else
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
              ),
              ),
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
  Future <SfCartesianChart> getGraph({required String symb})async
  {
    CurrentPriceStatus = await Currentstatus(name:symb);
    List<Stonks>Stonkdata = await FetchSeries(name:symb);
    return(
        SfCartesianChart(series: <CandleSeries>[
          CandleSeries<ChartData, DateTime>(
              bearColor: Colors.red.shade500,
              bullColor: Colors.green.shade600,
              dataSource: getChartData(length: Stonkdata.length, StockData: Stonkdata),
              xValueMapper: (ChartData sales, _) => sales.x,
              lowValueMapper: (ChartData sales, _) => sales.low,
              highValueMapper: (ChartData sales, _) => sales.high,
              openValueMapper: (ChartData sales, _) => sales.open,
              closeValueMapper: (ChartData sales, _) => sales.close)
        ], primaryXAxis: DateTimeAxis(labelStyle: TextStyle(color: Colors.white),
          majorGridLines: MajorGridLines(width: 0),),
            primaryYAxis: NumericAxis(labelStyle: TextStyle(color: Colors.white),),
            zoomPanBehavior: _zoomPanBehavior,
            tooltipBehavior: TooltipBehavior(enable: true)
        )
    );
  }
  List<ChartData> getChartData({required int length, required List<Stonks>StockData}) {
    return <ChartData>[
      for (int i = 0; i < length; i++)
        ChartData(
          x: StockData[i].Date_Time,
          open: StockData[i].open,
          close: StockData[i].close,
          low: StockData[i].low,
          high: StockData[i].high,
        )
    ];
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