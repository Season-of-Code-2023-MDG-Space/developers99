import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Services/ApiService.dart';
import 'dart:async';

Timer? timer;

class SearchScreen extends StatelessWidget{
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp(
      title: "SearchBar",
      home: SearchBarScreen(),
    );
  }
}

class SearchBarScreen extends StatefulWidget{
  const SearchBarScreen({super.key});
  @override
  State<SearchBarScreen> createState() => _SearchBarScreen();
}
@override
class _SearchBarScreen extends State<SearchBarScreen> {
  List<Result> lisres = [];
  int length = 0;

  final TextEditingController mycontroller = TextEditingController();

  Timer? searchOnStoppedTyping;

  _onChangeHandler() {
    const duration = Duration(milliseconds:200); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping!.cancel()); // clear timer
    }
    setState(() => searchOnStoppedTyping = Timer(duration, () async => lisres = await Search(searchterm: mycontroller.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(elevation: 10, title: Text("Search Bar"),),
        body:
        Column(
            children: [Material(
              elevation: 20,
              child:
              Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextField(controller: mycontroller,
                    onChanged: (text) {
                    if(text != '' && text != ' ')
                      {setState(() {
                        Future.delayed(Duration(milliseconds: 2000), () async {
                          if(text != ''){
                            _onChangeHandler();
                            length = lisres.length;}
                        });
                      });}
                    },
                    decoration: InputDecoration(border: OutlineInputBorder(),
                        hintText: "Enter the name..."),)
              ),
            ),
        if(length != 0 && mycontroller.text != '' && lisres != [])
          (
            Expanded(child: ListView.builder(
                padding: const EdgeInsets.only(top: 5),
                itemCount: length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    child: Container(
                      child: Row(children: [
                        Text(
                            lisres[index].Name.toString(),
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 15,)),
                        Text(
                            lisres[index].Symbol.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 15,))
                      ]),
                    ),
                  );
                })))
              else
                (
                  Icon(Icons.circle_outlined)
                )
        ]));
  }
}