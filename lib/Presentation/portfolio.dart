//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trading_app/Presentation/sidemenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trading_app/Services/firebase.dart';
//import 'graph.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading_app/Services/ApiService.dart';
import 'dart:async';

//Timer? timer;

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});
  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp(
      title: "PortfolioPage",
      home: PortfolioPageScreen(),
    );
  }
}

class PortfolioPageScreen extends StatefulWidget{
  const PortfolioPageScreen({super.key});
  @override
  State<PortfolioPageScreen> createState() => _PortfolioPage();
}

class _PortfolioPage extends State<PortfolioPageScreen> {
  List<User>? stonks;
  @override
  void initState() {
    super.initState();
    //timer = Timer.periodic(Duration(seconds:2), (Timer t) => ChangeVar(interv: _interval));
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }
  //void RefreshData();
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(elevation: 10,shadowColor: Colors.black,
          backgroundColor: Colors.blue.shade900,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          centerTitle: true,
          title: const Text("PORTFOLIO", style:TextStyle(fontFamily: 'ConcertOne',fontSize: 25)),
        ),
            drawer: NavDrawer(),
            body:
            StreamBuilder<List<User>>(
              stream: readUserStocks(),
              builder: (context, snapshot){
                if(snapshot.hasError){
                  return Center(
                      child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children:const [
                            Icon(Icons.error,
                              color: Colors.red,
                              size: 90,
                              shadows: [Shadow(offset: Offset(5, 5),
                                  blurRadius: 10, color: Colors.black38)],),
                            Text("NO DATA FOUND",
                              style: TextStyle(color: Colors.red,
                                fontSize: 30,
                                shadows: [Shadow(offset: Offset(5, 5),
                                    blurRadius: 10, color: Colors.black26)],),)]
                      ));
                }
                else if(snapshot.hasData)
                {
                  stonks = snapshot.data!;
                  return (
                      ListView(padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
                        itemExtent: 125,
                        children:
                          stonks!.map(buildUser).toList(),
                      ));
                }
                else
                {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ));
  }
  Widget buildUser(User user) =>
        Padding(padding: const EdgeInsets.only(top: 25),
        child:
        Container(
                decoration:const BoxDecoration(color: Color.fromRGBO(6, 27, 59, 1),
                    boxShadow:[BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.35),
                      blurRadius: 6.0,
                      spreadRadius: 3,
                      offset: Offset(
                        4,
                        4,
                      ),
                    ),],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                shape: BoxShape.rectangle,
                ),
                child:Padding(padding: const EdgeInsets.only(top: 10),
                    child:ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //leading: CircleAvatar(radius: 30,child: Text(user.stockvol.toString()),),
                title: Row(
                children:[Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                          Text('${user.stockvol}QTY.  AVG.150',
                            style: const TextStyle(fontSize: 20,fontFamily: "Homenaje", height: 0.4, color: Color.fromRGBO(102, 115, 132, 1),
                            ),),
                        Column(//crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(user.name.toUpperCase(),style: const TextStyle(
                        fontSize: 30, fontFamily: "MonomaniacOne",color: Colors.white, height: 1.3)),
                      Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children:[Text("(${user.symbol})",style: const TextStyle(
                        fontSize: 20, fontFamily: "MonomaniacOne",color: Color.fromRGBO(67, 93, 126, 1), height: 0.6),),]),
                    Padding(padding: const EdgeInsets.only(top: 0),
                    child:Column(children:[
                Text('INVESTED.${user.stockvol * user.buyprice}',style: const TextStyle(fontFamily: "Homenaje",fontSize: 20,color: Color.fromRGBO(123, 147, 176, 1)),)]))]),
  //                 SizedBox(height: 200,
  //                     width: 200,
  //                     child:FutureBuilder<SfCartesianChart>(
  //                       future: getGraph(symb: user.symbol),
  //                       builder: (context, AsyncSnapshot<SfCartesianChart> snapshot){
  //                         if(snapshot.hasError){
  //                           return Center(
  //                               child: Row(mainAxisAlignment: MainAxisAlignment.center,
  //                                   children:const [
  //                                     Icon(Icons.error, color: Colors.red,size: 90,),
  //                               ]));
  //                         }
  //                         else if(snapshot.hasData)
  //                         {
  //                           final result = snapshot.data!;
  //
  //                           return (result);
  //                         }
  //                         else
  //                         {
  //                           return const Center(child: CircularProgressIndicator());
  //                         }
  //                       },
  //                     )
  // )
                      ]),const Spacer(),
                  Column(
                    children: [
                  const Text("CURRENT PRICE:",style: TextStyle(
                      fontSize: 20, fontFamily: "Homenaje",color: Color.fromRGBO(67, 93, 126, 1), height: 0.4),),
                    StreamBuilder<CurrentStat>(
                      stream: Stream.periodic(const Duration(seconds: 2)).asyncMap((_) async {
                        return Currentstatus(name: user.symbol);
                      }),
                      builder: (context, AsyncSnapshot<CurrentStat> snapshot){
                        if(snapshot.hasError){
                          return Center(
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children:const [
                                    Icon(Icons.error, color: Colors.red,size: 20,),
                                  ]));
                        }
                        else if(snapshot.hasData)
                        {
                          CurrentStat temp = snapshot.data!;
                          return(Column(children: [
                            Column(children: [Text("${temp.ChangeAmt}",
                              style: TextStyle(fontSize: 32, color: (temp.ChangeAmt! > 0)? Color(0xFF00FF38) : Color(0xFFFF0000)),),
                              Text("  (${temp.ChangePer}%)",
                                style: TextStyle(fontSize: 17,color: (temp.ChangePer! > 0)? Colors.green : Colors.red, height: 0.6),
                                ),
                            ]),
                            Row(children:[const Text("LTP. ", style: TextStyle(color: Color.fromRGBO(123, 147, 176, 1),
                                height: 1.45, fontSize: 20, fontFamily: "Homenaje"),),
                            Text("${temp.RegMarketPrice}", style:
                            const TextStyle(color: Colors.white, fontSize: 20, height: 1.45, fontFamily: "Homenaje"))]
                            ),
                          ]));
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                ],)
                ])
                    ))));
  // Future <SfCartesianChart> getGraph({required String symb})async
  // {
  //   List<Stonks>Stonkdata = await FetchSeries(name:symb);
  //   List<ChartData>_chartdata = getChartData(length: Stonkdata.length, StockData: Stonkdata);
  //   return(
  //       SfCartesianChart(plotAreaBorderColor: Colors.transparent,
  //         series: <CandleSeries>[
  //         CandleSeries<ChartData, DateTime>(
  //             bearColor: Colors.red.shade500,
  //             bullColor: Colors.green.shade600,
  //             dataSource: _chartdata,
  //             xValueMapper: (ChartData sales, _) => sales.x,
  //             lowValueMapper: (ChartData sales, _) => sales.low,
  //             highValueMapper: (ChartData sales, _) => sales.high,
  //             openValueMapper: (ChartData sales, _) => sales.open,
  //             closeValueMapper: (ChartData sales, _) => sales.close)
  //       ],  primaryXAxis: DateTimeAxis(
  //           isVisible: true,
  //           majorGridLines: const MajorGridLines(width: 0),),
  //           primaryYAxis: NumericAxis(majorGridLines: const MajorGridLines(width: 0),isVisible: true),
  //           tooltipBehavior: TooltipBehavior(enable: true),
  //           zoomPanBehavior: ZoomPanBehavior(
  //               //zoomMode: _zoomModeType,
  //               enableMouseWheelZooming: true,
  //               enableDoubleTapZooming: true,
  //               enablePinching: true,
  //               // Enables the selection zooming
  //               enableSelectionZooming: true
  //           ),
  //       )
  //   );
  // }
}
