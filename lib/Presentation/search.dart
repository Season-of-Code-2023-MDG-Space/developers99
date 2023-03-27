//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/Services/ApiService.dart';
//import 'dart:async';
//import '/Presentation/graph.dart';
import 'graph.dart';
//Timer? timer;
import 'buysell.dart';

class SearchScreen extends StatefulWidget{
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchBarScreen();
}

class _SearchBarScreen extends State<SearchScreen> {
  _SearchBarScreen();
  List<Result> lisres = [];
  int length = 0;

  final TextEditingController mycontroller = TextEditingController();
  String searchString = "AAPL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:  const Color(0xFF202D3E),
        appBar: AppBar(backgroundColor:const Color(0xFF303D4E),
        elevation: 10, centerTitle: true,
          title: const Text("SEARCH BAR", style: TextStyle(fontSize: 30, fontFamily: 'ConcertOne'),),
          shape: const RoundedRectangleBorder(
              borderRadius: 
              BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))),),
        body:
        Column(children:[
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child:TextField(
                    controller: mycontroller,
                    onChanged: (text){setState(() {
                      searchString = mycontroller.text;
                    });},
                    decoration: const InputDecoration(filled: true,fillColor: Colors.white,border: OutlineInputBorder(),
                        hintText: "Enter the name..."),)
              ),
        Expanded(child: FutureBuilder<List<Result>>(
          future: Search(searchterm: searchString),
          builder: (context, AsyncSnapshot<List<Result>> snapshot){
            if(snapshot.hasError){
              return Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children:const [
                  Icon(Icons.error, color: Colors.red,size: 90,
                    shadows: [Shadow(offset: Offset(5, 5),blurRadius: 10, color: Colors.black38)],),
                  Text("NO INPUT PROVIDED", style: TextStyle(color: Colors.red, fontSize: 30,
                    shadows: [Shadow(offset: Offset(5, 5),blurRadius: 10, color: Colors.black26)],),)]
              ));
            }
            else if(snapshot.hasData)
            {
              final result = snapshot.data!;

              return (
                  ListView(
                    children: result.map(buildUser).toList(),
                  ));
            }
            else
            {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),)
        ]));
  }
  Widget buildUser(Result res) => ListTile(tileColor: const Color(0xFF202D3E),
    leading: CircleAvatar(child: Text(res.Symbol![0])),
    subtitle: Text(res.Symbol!,style:const TextStyle(color: Colors.white70),),
    title: Text(res.Name!, style: const TextStyle(color: Colors.white),),
    onTap: (){Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => BuySellScreen(Stockname: res.Name!, Symbolname: res.Symbol!,)));
      StockName = res.Symbol!;
      StockLongName = res.Name!;},
    shape: const RoundedRectangleBorder(
      side: BorderSide(color: Colors.white70, width: 1,),
    ),
  );
}