import 'dart:async';
//import 'search.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import '/Services/ApiService.dart';
import 'sidemenu.dart';
import 'search1.dart';
import 'package:trading_app/Services/localstorage.dart';


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


class BottomSelectionWidget extends StatefulWidget {
  const BottomSelectionWidget({super.key});

  @override
  State<BottomSelectionWidget> createState() => _BottomSelectionWidgetState();
}

class _BottomSelectionWidgetState extends State<BottomSelectionWidget> {

  final String _StockName = UserSharedPreferences.getStockName() ?? "AAPL";
  final String _StockLongName = UserSharedPreferences.getStockNameLong() ?? "APPLE INC.";
  CurrentStat CurrentPriceStatus = CurrentStat();

  late ZoomPanBehavior _zoomPanBehavior;
  //List<Stonks>? StockIntra;

  Color passivebgbuttoncolour = const Color(0xff000033);
  Color activebgbuttoncolor = Color(0xff000063);
  Color activetxtcolor = Colors.white;
  Color passivetxtcolor = Colors.white60;

  String _interval = "1m";

  //late int length;
  @override
  void initState(){
    //_zoomModeType = ZoomMode.x;
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
        enableMouseWheelZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true
    );
  }

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
            Text(_StockName,style:const TextStyle(fontSize: 25, fontFamily: 'ConcertOne',),
                textAlign: TextAlign.center,),),
              Container(padding: const EdgeInsets.only(top: 10,),
                  child:Text(_StockLongName, style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w400, color: Colors.white54)))]),
            const Spacer(),
            FloatingActionButton(backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed:() {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SearchScreen1()));
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
                        return Currentstatus(name: _StockName);}),
                builder: (context, AsyncSnapshot<CurrentStat> snapshot){
                  if(snapshot.hasError){
                    return Center(
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              const Icon(Icons.error, color: Colors.red,size: 90,),
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
                    const Padding(
                      padding: EdgeInsets.only(left: 10, top: 2),
                      child: Text("DATA RANGE: ", style: TextStyle(color: Colors.white30),),
                    ),
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
                ]),
              Container(
                color: Colors.transparent,
                height: 400,
                child:StreamBuilder<SfCartesianChart>(
                  stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
                            return getGraph(symb: _StockName, interval: _interval, zpan: _zoomPanBehavior);}),
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
  Future <SfCartesianChart> getGraph({required String symb, required String interval, required ZoomPanBehavior zpan})async
  {
    CurrentPriceStatus = await Currentstatus(name:symb);
    List<Stonks>Stonkdata = await FetchSeries(name:symb, interval: interval, numberofresp: 0);
    return(
        SfCartesianChart(plotAreaBorderWidth: 0,
            series: <CandleSeries>[
              CandleSeries<ChartData, DateTime>(
                  bearColor: Color(0xFFFF0000),
                  bullColor: Colors.green,
                  dataSource: getChartData(length: Stonkdata.length, StockData: Stonkdata),
                  xValueMapper: (ChartData sales, _) => sales.x,
                  lowValueMapper: (ChartData sales, _) => sales.low,
                  highValueMapper: (ChartData sales, _) => sales.high,
                  openValueMapper: (ChartData sales, _) => sales.open,
                  closeValueMapper: (ChartData sales, _) => sales.close)
            ], primaryXAxis: DateTimeAxis(labelStyle: TextStyle(color: Colors.white),
              majorGridLines: const MajorGridLines(width: 0)
            ),
            primaryYAxis: NumericAxis(axisLine: AxisLine(width: 0),
              labelStyle: const TextStyle(fontSize: 0),
              majorGridLines: const MajorGridLines(color: Colors.white10,),
            ),
            zoomPanBehavior: zpan,
            tooltipBehavior: TooltipBehavior(enable: true, duration: 5)
        )
    );
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
