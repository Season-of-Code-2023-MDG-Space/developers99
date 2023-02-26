import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'Services/ApiService.dart';
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

class _SearchBarScreen extends State<SearchBarScreen>
{
  final TextEditingController mycontroller = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(elevation: 10,title: Text("Search Bar"),),
      body:
      Material(
        elevation: 20,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
            child: TextField(controller: mycontroller,
              decoration:
                InputDecoration(border: OutlineInputBorder(),
                hintText: "Enter the name..."),
      ))
    )
    );
  }
}