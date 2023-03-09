//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trading_app/Presentation/sidemenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trading_app/Services/firebase.dart';
import 'graph.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:trading_app/Services/ApiService.dart';
import 'dart:math';

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
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        backgroundColor: Colors.indigo.shade500,
        appBar: AppBar(elevation: 0,
          backgroundColor: Colors.indigo.shade900,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
          centerTitle: true,
          title: const Text("PORTFOLIO", style:TextStyle(fontFamily: 'ConcertOne',fontSize: 25)),
        ),
            drawer: NavDrawer(),
            body:Column(children:[Row(children:[Padding(padding: EdgeInsets.only(left: 10),
              child:Card(elevation: 5,
              child: Text("Company Name"),))]),
            Expanded(child: StreamBuilder<List<User>>(
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
                      ListView(padding: const EdgeInsets.all(10),
                        itemExtent: 200,
                        children:
                          stonks!.map(buildUser).toList(),
                      ));
                }
                else
                {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
            )]));
  }
  Widget buildUser(User user) =>
        Padding(padding: const EdgeInsets.only(top: 10),
        child:
        Card(color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 5,
                child:Padding(padding: const EdgeInsets.only(top: 10),
                    child:ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                //leading: CircleAvatar(radius: 30,child: Text(user.stockvol.toString()),),
                title: Column(
                      children:[Center(child:
                  Text(user.name.toUpperCase(),style: const TextStyle(
                    fontSize: 25, fontFamily: "RubikMono",color: Colors.red,),),),
                        Column(
                    children:[
                      Text("(${user.symbol})",style: const TextStyle(
                        fontSize: 20, fontFamily: "LondrinaSolid",color: Colors.black38,),),
                    Padding(padding: const EdgeInsets.only(),
                        child:Text('BuyPrice: ${user.buyprice}', style: const TextStyle(fontSize: 20,fontFamily: "LondrinaSolid"),)),
                      Padding(padding: const EdgeInsets.only(),
                          child:Text('Stock: ${user.stockvol}', style: const TextStyle(fontSize: 20,fontFamily: "LondrinaSolid"),)),
                    Padding(padding: const EdgeInsets.only(),
                    child:Column(children:[
                Text('SHARES OWNED: ${user.stockvol}',style: TextStyle(fontFamily: "LondrinaSolid",fontSize: 20),)]))]),
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
                      ])))));

  Future <SfCartesianChart> getGraph({required String symb})async
  {
    List<Stonks>Stonkdata = await FetchSeries(name:symb);
    List<ChartData>_chartdata = getChartData(length: Stonkdata.length, StockData: Stonkdata);
    return(
        SfCartesianChart(plotAreaBorderColor: Colors.transparent,
          series: <CandleSeries>[
          CandleSeries<ChartData, DateTime>(
              bearColor: Colors.red.shade500,
              bullColor: Colors.green.shade600,
              dataSource: _chartdata,
              xValueMapper: (ChartData sales, _) => sales.x,
              lowValueMapper: (ChartData sales, _) => sales.low,
              highValueMapper: (ChartData sales, _) => sales.high,
              openValueMapper: (ChartData sales, _) => sales.open,
              closeValueMapper: (ChartData sales, _) => sales.close)
        ],  primaryXAxis: DateTimeAxis(
            isVisible: true,
            majorGridLines: const MajorGridLines(width: 0),),
            primaryYAxis: NumericAxis(majorGridLines: const MajorGridLines(width: 0),isVisible: true),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
                //zoomMode: _zoomModeType,
                enableMouseWheelZooming: true,
                enableDoubleTapZooming: true,
                enablePinching: true,
                // Enables the selection zooming
                enableSelectionZooming: true
            ),
        )
    );
  }
}
