import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trading_app/cardDesign.dart';
import 'package:trading_app/dataset.dart';
import 'Presentation/sidemenu.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.indigo.shade900,
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                ),
              ),
            ),
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
                ), //Currency Market Container
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      Row(
                        children: const [
                          Text("Your Trades",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[300],
                        child: const Center(child: Text("Entry A"),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[500],
                        child: const Center(child: Text("Entry B", style: TextStyle(color: Colors.white),),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[300],
                        child: const Center(child: Text("Entry C"),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[500],
                        child: const Center(child: Text("Entry D",style: TextStyle(color: Colors.white),),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[300],
                        child: const Center(child: Text("Entry E"),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[500],
                        child: const Center(child: Text("Entry F",style: TextStyle(color: Colors.white),),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[300],
                        child: const Center(child: Text("Entry G"),),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 50,
                        color: Colors.indigo[500],
                        child: const Center(child: Text("Entry H",style: TextStyle(color: Colors.white),),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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

