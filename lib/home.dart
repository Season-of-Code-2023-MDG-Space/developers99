import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trading_app/Services/firebase.dart';
import 'package:trading_app/cardDesign.dart';
import 'package:trading_app/dataset.dart';
import 'Presentation/sidemenu.dart';
import 'package:trading_app/Services/firebase.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    //timer = Timer.periodic(Duration(seconds:2), (Timer t) => ChangeVar(interv: _interval));
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Transactions", style:TextStyle(fontFamily: 'ConcertOne',fontSize: 25)),
        elevation: 0.0,
        // shape: RoundedRectangleBorder(borderRadius:
        // BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
        backgroundColor: Colors.indigo.shade900,
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () => ,
        // ),
        // actions: [
        //   IconButton(onPressed: ()=>debugPrint('setting'), icon: const Icon(Icons.settings))
        // ],
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                           // borderRadius: new BorderRadius.vertical(
                           //   bottom: Radius.elliptical(150, 30)),
                          color: Colors.indigo.shade900,
                          ),
                        ),
                    ],),),
                    Padding(padding: EdgeInsets.only(top:120),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.vertical(
                              top: Radius.circular(20)),
                          color: Colors.grey[50],
                        ))),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //
                //     decoration: const BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                //     ),
                //   ),
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: CardList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(30),),
                        color: Colors.indigo.shade50,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            blurRadius: 7.0,
                            spreadRadius: 1.0,
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("Currency Market",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Open Chart",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: const [
                                Currency(currency: "EUR/USD", value: "14,321"),
                                Currency(currency: "USD/GBP", value: "5,419"),
                                Currency(currency: "USD/RUB", value: "10,221"),
                                Currency(currency: "XAU/USD", value: "17,563"),
                                Currency(currency: "AUD/USD", value: "3,454"),
                                Currency(currency: "NZD/USD", value: "8,946"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                          const SizedBox(
                            height: 20,
                            ),//Currency Market Container
                    Text("Your Trades",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                    const SizedBox(
                      height: 20,
                    ),
                StreamBuilder<List<TransHis>>(
                  stream: readTransacHist(),
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
                      List<TransHis> transhislist = snapshot.data!;
                      return Container(//color: Colors.white,
                        height: 500,
                        child: (
                            ListView(padding: const EdgeInsets.only(left: 10, right: 10),
                              //itemExtent: 125,
                              children:
                              transhislist.map(buildUser).toList(),
                            )),
                      );
                    }
                    else
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
      ])]),
          ],
        )
    ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed:() {
            createUser(name: "ChaggiKing", noofshares: 122);
          },
        ),
    );
  }
  Widget buildUser(TransHis res) => Card(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),
      //side: BorderSide(color: Colors.black87, width: 1,),
    ),
    elevation: 5,
    child:Container
      (decoration: const BoxDecoration(
      // gradient: LinearGradient(
      //   begin: Alignment.centerRight,
      //   end: Alignment(0.1, 1),
      //   colors: <Color>[
      //     Color(0xfffbf4e2),
      //     Color(0xffd8f0fa),
      //   ], // Gradient from https://learnui.design/tools/gradient-generator.html
      //   //tileMode: TileMode.mirror,
      // ),
    ),
      child: ListTile(
      leading: CircleAvatar(radius: 30,
          backgroundColor: Colors.blue.shade50,
          child:
        Column(
        children: [
          const SizedBox(
          height: 9,
        ),
          Text('${res.noofshares}',),
          Text('${res.transactiontype}',style: TextStyle(
            color: res.transactiontype == "buy" ? Colors.green.shade300 : Colors.red.shade300
          ),)
        ],
      )),
      subtitle: Row(
          children:[
            Text('Price/Stock: ${res.sellprice}',
              style:const TextStyle(color: Colors.black54),),
            Spacer(),
            Text('Date: ${res.date!.toDate()}'.substring(0,16),
              style:const TextStyle(color: Colors.black54),)
          ]),
      title: Column(
        children: [
          Text('${res.name} ', style: const TextStyle(color: Colors.indigo,
              fontFamily: 'MonomaniacOne', fontSize: 25,)),
            Row(
              children: [
                Text("SharesAmt. ${res.noofshares} ",style: const TextStyle(color: Colors.black54)),
                Spacer(),
                Text("NetAmt. ${res.netamount}",style: const TextStyle(color: Colors.black54)),
              ],
            )
        ],
      ),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)),
        //side: BorderSide(color: Colors.black87, width: 1,),
      ),
      ),)
  );
}

class CardList extends StatelessWidget {
  const CardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: cards.length,
        itemBuilder: (BuildContext context,int i,int index){
          return CardDesign(card: cards[index]);
        },
        options: CarouselOptions(initialPage: 0, enableInfiniteScroll: false, enlargeCenterPage: true),
    );
  }
}

class Currency extends StatelessWidget {
  final String currency;
  final String value;
  const Currency({super.key, required this.currency,required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: 120,
      height: 90,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: const Color(0xFF333333).withOpacity(0.14),
          blurRadius: 2,
          offset: const Offset(0,2),
        ),],
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(currency, style: const TextStyle(
            color: Colors.black54,
          ),),
          const SizedBox(
            height: 5,
          ),
          Text(value,style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),)
        ],
      ),
    );
  }
}


