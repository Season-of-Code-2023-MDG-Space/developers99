import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trading_app/Presentation/sidemenu.dart';
import 'graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading_app/Services/ApiService.dart';

Timer? timer1;

class BuySellScreen extends StatefulWidget{
  BuySellScreen({super.key, required this.Stockname, required this.Symbolname});
  String Stockname;
  String Symbolname;
  @override
  State<BuySellScreen> createState() => _BuySellScreen();
}

class _BuySellScreen extends State<BuySellScreen> {
  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
        enableMouseWheelZooming: true,
        enableDoubleTapZooming: true,
        enablePinching: true,
        // Enables the selection zooming
        enableSelectionZooming: true
    );
  final List<String> _list = <String>['1m', '1D', '5D', '15D', '1YR', '5YR', '20YR'];
  Map intermap = {'1m': '1m', '1D': '1m', '5D': '5m', '15D': '15m', '1YR': '1d', '5YR': '1wk', '20YR': '1mo'};
  List<Stonks> tempfetch = [];
  CurrentStat? tempfetchprice;
  List<ChartData> list1 = [];
  int? _pointIndex;
  String _range = "1D";
  int datasize = 0;
  int maxsize = 0;

  int off = 0;
  ChartData? tempchartdata;
  ChartSeriesController? _chartSeriesController;
  @override
  void initState() {
    super.initState();
    //callApi();
    if(off == 0)
    {timer1 = Timer.periodic(Duration(seconds: 2), (timer){ChangeData();});}
  }

  @override
  void dispose() {
    timer1!.cancel();
    super.dispose();
  }
  
  Future ChangeData() async
  {
    if (_range == '1m'){tempfetch = await FetchSeries(name:"AAPL", interval: intermap[_range], numberofresp:50);}
    else
    {tempfetch = await FetchSeries(name:"AAPL", interval: intermap[_range], numberofresp:datasize);}
    tempfetchprice = await Currentstatus(name: widget.Symbolname);
    int tempmax = tempfetch.length;
    setState(() {
      list1 = getChartData(length: tempfetch.length, StockData: tempfetch); 
      if(_pointIndex == null || _pointIndex! >= tempfetch.length)
      {
        _pointIndex = tempfetch.length - 1;
      }
      if(maxsize < tempmax){maxsize = tempmax;}
    });
  }     

  Padding paddingwidget(){
  return const Padding(padding: EdgeInsets.only(left: 3, right: 3),
          child: SizedBox(
            width: 1,
            height: 30,
            child: VerticalDivider(thickness: 2, color: Colors.blueGrey,)
      ),);}

  Padding paddingwidget1(){
  return const Padding(padding: EdgeInsets.only(left: 20, right: 20),
          child: SizedBox(
            width: 1,
            height: 30,
            child: VerticalDivider(thickness: 2, color: Colors.black12,)
      ),);}
  
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      drawer: NavDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Card(shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
              ),
              color: Color.fromARGB(255, 10, 58, 131),
              child: Column(children: [                
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(widget.Symbolname, style: const TextStyle(fontSize: 25, color: Colors.white)),
                ),
                Text("(${widget.Stockname})", style: const TextStyle(fontSize: 15, color: Colors.white),),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("CHANGE: ", style: TextStyle(fontSize: 15, color: Colors.yellow.shade500),),
                    Text(tempfetchprice!.ChangeAmt.toString().substring(0,tempfetchprice!.ChangeAmt.toString().length - 1 >= 6? 6: tempfetchprice!.ChangeAmt.toString().length - 1), style: TextStyle(fontSize: 25,
                    color: (tempfetchprice!.ChangeAmt! > 0)? Colors.lightGreen : Colors.red)),
                    Text("(${tempfetchprice!.ChangePer.toString().substring(0,tempfetchprice!.ChangePer.toString().length - 1 >= 6? 6: tempfetchprice!.ChangeAmt.toString().length - 1)}%)", style: TextStyle(fontSize: 15,
                    color: (tempfetchprice!.ChangePer! > 0)? Colors.lightGreen : Colors.red)),
                  ],
                ),
                Center(
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Column(
                            children:[
                              Text("CURRENT.", style: TextStyle(color: Colors.yellow.shade500), textAlign: TextAlign.center,),
                              Row(
                                children: [
                                  Text("${tempfetch.last.close.toString().substring(0,tempfetch.last.close.toString().length - 1 >= 6? 6: tempfetch.last.close.toString().length - 1)}",
                                  style: TextStyle(color: (tempfetchprice!.ChangeAmt! > 0)? Colors.lightGreen : Colors.red, fontSize: 25),textAlign: TextAlign.center,),
                                  Icon((tempfetchprice!.ChangeAmt! > 0)? Icons.arrow_upward : Icons.arrow_downward, color: (tempfetchprice!.ChangeAmt! > 0)? Colors.lightGreen : Colors.red)
                                ],
                              )
                            ]
                          ),
                          paddingwidget(),
                          Column(
                            children:[
                              Text("OPEN:", style: TextStyle(color: Colors.yellow.shade500), textAlign: TextAlign.center,),
                              Row(
                                children: [
                                  Text("${tempfetch.last.open.toString().substring(0,tempfetch.last.open.toString().length - 1 > 6? 6: tempfetch.last.open.toString().length - 1)}",
                                  style: TextStyle(color: Colors.grey, fontSize: 25),textAlign: TextAlign.center,),
                                ],
                              )
                            ]
                          ),
                          paddingwidget(),
                          Column(
                            children:[
                              Text("HIGH:", style: TextStyle(color: Colors.yellow.shade500), textAlign: TextAlign.center,),
                              Row(
                                children: [
                                  Text("${tempfetch.last.high.toString().substring(0,tempfetch.last.high.toString().length - 1 > 6? 6: tempfetch.last.high.toString().length - 1)}",
                                  style: TextStyle(color: Colors.green, fontSize: 25),textAlign: TextAlign.center,),
                                ],
                              )
                            ]
                          ),
                          paddingwidget(),
                          Column(
                            children:[
                              Text("LOW:", style: TextStyle(color: Colors.yellow.shade500), textAlign: TextAlign.center,),
                              Row(
                                children: [
                                  Text("${tempfetch.last.low.toString().substring(0,tempfetch.last.low.toString().length - 1 > 6? 6: tempfetch.last.low.toString().length - 1)}",
                                  style: TextStyle(color: Colors.red, fontSize: 25),textAlign: TextAlign.center,),
                                ],
                              )
                            ]
                          ),                                                                     
                        ]
                      ),
                )
              ]),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 250,
              width: MediaQuery.of(context).size.width - 10,
              child: Card(
                  color: Colors.white,
                  elevation: 0,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Text("DATA RANGE: ", style: TextStyle(color: Colors.black12),),
                    ),
                          DropdownButton<String>(
                              value: _range,
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
                                _range = value!;
                              });
                              },
                              items: _list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                              );
                              }).toList(),
                            ),
                            Spacer(),
                            FloatingActionButton(child: Icon(Icons.zoom_out),
                              onPressed:() 
                            {setState(() {
                              _zoomPanBehavior.reset();
                            });})
                        ],
                      ),
                    //   Row(
                    //     children: [
                    //       const Padding(
                    //       padding: const EdgeInsets.only(left: 10, top: 2),
                    //       child: Text("INTERVAL: ", style: TextStyle(color: Colors.black12),),
                    // ),
                    //       DropdownButton<String>(
                    //           value: _interval,
                    //           icon: const Icon(Icons.arrow_downward),
                    //           elevation: 16,
                    //           style: const TextStyle(color: Colors.deepPurple),
                    //           underline: Container(
                    //           height: 2,
                    //           color: Colors.deepPurpleAccent,
                    //           ),
                    //           onChanged: (String? value) {
                    //           // This is called when the user selects an item.
                    //           setState(() {
                    //             _interval = value!;
                    //           });
                    //           },
                    //           items: _list1.map<DropdownMenuItem<String>>((String value) {
                    //           return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value),
                    //           );
                    //           }).toList(),
                    //         ),
                    //     ],
                    //   ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: FutureBuilder<List<Stonks>>(
                          future: FetchSeries(name:"AAPL", interval: "1m"),
                          builder: (context, AsyncSnapshot<List<Stonks>> snapshot){
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
                              tempfetch = result;                                                    
                              return (SfCartesianChart(plotAreaBorderWidth: 0,      
                                        onChartTouchInteractionDown: (tapArgs) => off = 1,
                                        onChartTouchInteractionUp: (tapArgs) => off = 0,                         
                                        series: <CandleSeries>[
                                          CandleSeries<ChartData, DateTime>(
                                              onPointTap: (pointInteractionDetails) => {
                                                _pointIndex = pointInteractionDetails.pointIndex},                                    
                                              bearColor: const Color.fromARGB(255, 196, 7, 7),
                                              bullColor: const Color.fromARGB(255, 59, 131, 61),
                                              dataSource: list1,                                        
                                              xValueMapper: (ChartData sales, _) => sales.x,
                                              lowValueMapper: (ChartData sales, _) => sales.low,
                                              highValueMapper: (ChartData sales, _) => sales.high,
                                              openValueMapper: (ChartData sales, _) => sales.open,
                                              closeValueMapper: (ChartData sales, _) => sales.close)
                                        ], primaryXAxis: DateTimeAxis(labelStyle: TextStyle(color: Colors.black),
                                          majorGridLines: const MajorGridLines(width: 0),
                                        ),                                        
                                        primaryYAxis: NumericAxis(axisLine: AxisLine(width: 0),
                                          labelStyle: const TextStyle(fontSize: 0),
                                          majorGridLines: const MajorGridLines(color: Colors.black26,),
                                        ),
                                        zoomPanBehavior: _zoomPanBehavior,
                                        tooltipBehavior: TooltipBehavior(enable: true, 
                                        duration: 5)
                                    )
                                );
                            }
                            else
                            {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Column(
                                children:[
                                  Text("CLOSE", style: TextStyle(color: Color(0xFFC1C1C2),fontSize: 15), textAlign: TextAlign.center,),
                                  Row(
                                    children: [
                                      Text(tempfetch[_pointIndex!].close.toString().substring(0, tempfetch[_pointIndex!].close.toString().length - 1 > 6? 6: tempfetch[_pointIndex!].close.toString().length - 1),
                                      style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 20),textAlign: TextAlign.center,),                                      
                                    ],
                                  )
                                ]
                              ),
                              paddingwidget1(),
                              Column(
                                children:[
                                  Text("OPEN:", style: TextStyle(color: Color(0xFFC1C1C2),fontSize: 15), textAlign: TextAlign.center,),
                                  Row(
                                    children: [
                                      Text(tempfetch[_pointIndex!].open.toString().substring(0,tempfetch[_pointIndex!].close.toString().length - 1 > 6? 6: tempfetch[_pointIndex!].close.toString().length - 1),
                                      style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 20),textAlign: TextAlign.center,),
                                    ],
                                  )
                                ]
                              ),
                              paddingwidget1(),
                              Column(
                                children:[
                                  Text("HIGH:", style: TextStyle(color: Color(0xFFC1C1C2), fontSize: 15), textAlign: TextAlign.center,),
                                  Row(
                                    children: [
                                      Text(tempfetch[_pointIndex!].high.toString().substring(0,tempfetch[_pointIndex!].close.toString().length - 1 > 6? 6: tempfetch[_pointIndex!].close.toString().length - 1),
                                      style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 20),textAlign: TextAlign.center,),
                                    ],
                                  )
                                ]
                              ),
                              paddingwidget1(),
                              Column(
                                children:[
                                  Text("LOW:", style: TextStyle(color: Color(0xFFC1C1C2),fontSize: 15), textAlign: TextAlign.center,),
                                  Row(
                                    children: [
                                      Text(tempfetch[_pointIndex!].low.toString().substring(0,tempfetch[_pointIndex!].close.toString().length - 1 > 6? 6: tempfetch[_pointIndex!].close.toString().length - 1),
                                      style: TextStyle(color: Color(0xFFA0A0A0), fontSize: 20),textAlign: TextAlign.center,),
                                    ],
                                  )
                                ]
                              ),                                                                     
                            ]
                          ),
                          Text("${tempfetch[_pointIndex!].Date_Time}", style: TextStyle(color: Color(0xFFC1C1C2),fontSize: 15), textAlign: TextAlign.center,),
                    ],
                  ),
              ),
            ),
          ),
          Row(children: [
            Container(width: 90,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue.shade900),
               borderRadius: BorderRadius.all(Radius.circular(5))),
              child: FloatingActionButton(onPressed: null,
              child: Text("WISHLIST+", style: TextStyle(color: Colors.blue.shade900),),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              backgroundColor: Colors.white,),
            ),
            Spacer(),
            Container(width: 80,
              child: FloatingActionButton(onPressed: null,
              backgroundColor: Colors.blue.shade900,
              child: Text("SELL"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),),
            ),
            SizedBox(width: 10,),
            Container(width: 80,
              child: FloatingActionButton(onPressed: null,
              backgroundColor: Colors.blue.shade900,
              child: Text("BUY"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),),
            ),
          ],)
      ])
    );
  }
}