import 'dart:async';
//import 'search.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '/Services/ApiService.dart';
import 'sidemenu.dart';
import 'search.dart';

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
String StockName = "AAPL";
String StockLongName = "APPLE INC.";

late ZoomPanBehavior _zoomPanBehavior;

class BottomSelectionWidget extends StatefulWidget {
  const BottomSelectionWidget({super.key});

  @override
  State<BottomSelectionWidget> createState() => _BottomSelectionWidgetState();
}

class _BottomSelectionWidgetState extends State<BottomSelectionWidget> {

  List<Stonks>? StockIntra;

  Color passivebgbuttoncolour = const Color(0xff000033);
  Color activebgbuttoncolor = Color(0xff000063);
  Color activetxtcolor = Colors.white;
  Color passivetxtcolor = Colors.white60;
  String _interval = "1m";
  //late int length;
  CurrentStat CurrentPriceStatus = new CurrentStat();
  @override
  void initState(){
    //_zoomModeType = ZoomMode.x;
    _zoomPanBehavior = ZoomPanBehavior(
        enableMouseWheelZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true
    );
    // setState(() {
    //   Future.delayed(Duration.zero,() async {
    //     //StockIntra = await FetchSeries(name:_StockName);
    //   CurrentPriceStatus = await Currentstatus(name: _StockName);
    //   });
    //
    //    //length = StockIntra!.length;
    //    //_chartData = getChartData(length: length, StockData: StockIntra!);
    //   //timer = Timer.periodic(Duration(seconds:2), (Timer t) => ChangeVar(interv: _interval));
    //  });
    // super.initState();
  }
  // void ChangeVar({required String interv})async
  // {
  //   setState((){
  //     Future.delayed(Duration(milliseconds: 200),() async {
  //       //StockIntra = await FetchSeries(name:_StockName , interval: interv);
  //       CurrentPriceStatus = await Currentstatus(name: _StockName);
  //     });
  //     _interval = interv;
  //     //length = StockIntra!.length;
  //     //_chartData = getChartData(length: length,  StockData: StockIntra!);
  //   });
  // }

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
  List<String> list = <String>['1m', '30m', '60m', '1D', '1wk', '1mo'];
  //int i = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(32, 45, 62, 0.6),
        drawer: NavDrawer(),
        appBar: AppBar(elevation: 0,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
          title: Row(children: [Spacer(),
            Column(children:<Widget>[Container(
              alignment: Alignment.center,
              child:
            Text(StockName,style:const TextStyle(fontSize: 25, fontFamily: 'ConcertOne',),
                textAlign: TextAlign.center,),),
              Container(padding: const EdgeInsets.only(top: 10,),
                  child:Text(StockLongName, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.white54)))]),
            const Spacer(),
            FloatingActionButton(backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed:() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchScreen()));
              },
              child: const Icon(Icons.search),)
          ]),
          centerTitle: true,
        ),
        body:
        Column(
            children :[
              StreamBuilder<CurrentStat>(
                stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
                        return Currentstatus(name: StockName);}),
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
                  Padding(padding: EdgeInsets.only(left: 10),
                    child:
                    DropdownButton<String>(
                    value: _interval,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      _interval = value!;
                    });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    );
                    }).toList(),
                    ),
                        // Container(
                        //     height: 30,
                        //     width: 40,
                        //     decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                        //     margin:EdgeInsets.all(1),
                        //     child: FloatingActionButton(backgroundColor: bgbuttoncolor("1m"),
                        //         shape: RoundedRectangleBorder(),
                        //         onPressed: (){
                        //           //ChangeVar(interv: "1m");
                        //           //setState(() {
                        //             _interval = "1m";
                        //           //});
                        //         },
                        //         child: Text("1min", style: TextStyle(color: txtbuttoncolor("1m")),
                        //         )
                        //     )),
                      //   Container(
                      //       height: 30,
                      //       width: 40,
                      //       margin:EdgeInsets.all(1),
                      //       decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("5m"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "5m");
                      //           // setState(()
                      //           // {
                      //               _interval = "5m";
                      //            // });
                      // },
                      //         child: Text("5min", style: TextStyle(color: txtbuttoncolor("5m")),),
                      //       )
                      //   ),
                      //   Container(
                      //       height: 30,
                      //       width: 50,
                      //       margin:EdgeInsets.all(1),
                      //       decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("15m"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "15m");
                      //           // setState(()
                      //           // {
                      //             _interval = "15m";
                      //           // });
                      //         },
                      //         child: Text("15min", style: TextStyle(color: txtbuttoncolor("15m")),),
                      //       )
                      //   ),Container(
                      //       height: 30,
                      //       width: 50,
                      //       margin:EdgeInsets.all(1),
                      //       decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("30m"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "30m");
                      //           // setState(()
                      //           // {
                      //             _interval = "30m";
                      //           // });
                      //         },
                      //         child: Text("30min", style: TextStyle(color: txtbuttoncolor("30m")),),
                      //       )
                      //   ),Container(
                      //       height: 30,
                      //       width: 50,
                      //       margin:EdgeInsets.all(1),
                      //       decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("60m"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "60m");
                      //           // setState(()
                      //           // {
                      //             _interval = "60m";
                      //           // });
                      //         },
                      //         child: Text("60min", style: TextStyle(color: txtbuttoncolor("60m")),),
                      //       )
                      //   ),
                      //   Container(
                      //       height: 30,
                      //       width: 50,
                      //       margin:EdgeInsets.all(1),
                      //       decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("1d"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "1d");
                      //             _interval = "1d";
                      //         },
                      //         child: Text("1 Day", style: TextStyle(color: txtbuttoncolor("1d")),),
                      //       )
                      //   ),
                      //   Container(
                      //       height: 30,
                      //       width: 50,
                      //       margin:EdgeInsets.all(1),
                      //       decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.white54))),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("1wk"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "1wk");
                      //           // setState(()
                      //           // {
                      //             _interval = "1wk";
                      //           // });
                      //         },
                      //         child: Text("1week", style: TextStyle(color: txtbuttoncolor("1wk")),),
                      //       )
                      //   ),
                      //   Container(
                      //       height: 30,
                      //       width: 60,
                      //       margin:EdgeInsets.all(1),
                      //       child: FloatingActionButton(backgroundColor: bgbuttoncolor("1mo"),
                      //         shape: RoundedRectangleBorder(),
                      //         onPressed: (){
                      //           // ChangeVar(interv: "1mo");
                      //           // setState(()
                      //           // {
                      //             _interval = "1mo";
                      //           // });
                      //         },
                      //         child: Text("1month", style: TextStyle(color: txtbuttoncolor("1mo")),),
                      //       )
                      //   ),
                  ),
                ]),
              Container(
                color: Colors.transparent,
                height: 400,
                child:StreamBuilder<SfCartesianChart>(
                  stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
                            return getGraph(symb: StockName);}),
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
    List<Stonks>Stonkdata = await FetchSeries(name:symb, interval: _interval);
    return(
        SfCartesianChart(plotAreaBorderWidth: 0,
            series: <CandleSeries>[
          CandleSeries<ChartData, DateTime>(
              bearColor: Colors.red.shade800,
              bullColor: Colors.green.shade800,
              dataSource: getChartData(length: Stonkdata.length, StockData: Stonkdata),
              xValueMapper: (ChartData sales, _) => sales.x,
              lowValueMapper: (ChartData sales, _) => sales.low,
              highValueMapper: (ChartData sales, _) => sales.high,
              openValueMapper: (ChartData sales, _) => sales.open,
              closeValueMapper: (ChartData sales, _) => sales.close)
        ], primaryXAxis: DateTimeAxis(labelStyle: TextStyle(color: Colors.white),
          majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(axisLine: AxisLine(width: 0),
                labelStyle: const TextStyle(fontSize: 0),
                majorGridLines: const MajorGridLines(color: Colors.white10,),
            ),
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