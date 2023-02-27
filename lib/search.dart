import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Services/ApiService.dart';
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

  void changeres({required String searchter}) async
  {
    lisres = await Search(searchterm: searchter);
    length = lisres.length;
  }

  final TextEditingController mycontroller = TextEditingController();

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
                      changeres(searchter: mycontroller.text);
                    },
                    decoration: InputDecoration(border: OutlineInputBorder(),
                        hintText: "Enter the name..."),)
              ),
            ),]
        )
    );
  }
    @override
    Widget buildSugg(BuildContext context)
    {
      return(
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
              })
          )
      );
    }
}