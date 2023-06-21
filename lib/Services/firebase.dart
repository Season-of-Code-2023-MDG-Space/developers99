import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trading_app/Services/localstorage.dart';
import 'package:trading_app/dataset.dart';

Stream<List<User>> readUserStocks() => FirebaseFirestore.instance
      .collection('Stonks') //gets all collection
      //.orderBy('date', descending: true)
      .snapshots()  //gets all documents
      .map((snapshot) =>  //returns a query snapshot of map string dynamic so that we get some json data.
  snapshot.docs.map(((doc) => User.fromJson(doc.data()))).toList()); //first go to each document data then convert json data to user objects   //which gets converted to list data later.

Stream<List<TransHis>> readTransacHist() => FirebaseFirestore.instance
    .collection('Transac. History') //gets all collection
//.orderBy('date', descending: true)
    .snapshots()  //gets all documents
    .map((snapshot) =>  //returns a query snapshot of map string dynamic so that we get some json data.
snapshot.docs.map(((doc) => TransHis.fromJson(doc.data()))).toList());

Future createtransac({required String name, required num noofshares, 
required num netamt, required num sellprice, required String transactype}) async{
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  final docUser = FirebaseFirestore.instance.collection('Transac. History').doc();

  final json = {
    'date': Timestamp.now(),
    'name': name,
    'netamount': netamt,
    'noofshares': noofshares,
    'sellprice': sellprice,
    'transactiontype': transactype,
  };

  await docUser.set(json);
}

Future createstock({required String collectionname, required String stockname, 
required String type, required num buyprice, required num noofshares, required String symbol}) async{
  try {
        await FirebaseFirestore.instance.collection(collectionname)
        .doc(stockname).get().then((doc) async{
            if(type == "buy")
            {
              final json = {
                'date': Timestamp.now(),
                'name': stockname,
                'symbol': symbol ,
                'noofshares': noofshares + doc.get('noofshares'),
                'buyprice': buyprice + doc.get('buyprice'),
              };
              UserSharedPreferences.setBalance1(UserSharedPreferences.getBalance1() - buyprice);
              if(noofshares + doc.get('noofshares') <= 0)
              {
                await FirebaseFirestore.instance.collection(collectionname)
                .doc(stockname).delete();
              }
              else
              {await FirebaseFirestore.instance.collection(collectionname)
                .doc(stockname).set(json);}
            }
            else{
              final json = {
                'date': Timestamp.now(),
                'name': stockname,
                'symbol': symbol ,
                'noofshares': noofshares - doc.get('noofshares'),
                'buyprice': buyprice - doc.get('buyprice'),
              };
              UserSharedPreferences.setBalance1(UserSharedPreferences.getBalance2() - buyprice);
              if(noofshares + doc.get('noofshares') <= 0)
              {
                await FirebaseFirestore.instance.collection(collectionname)
                .doc(stockname).delete();
              }
              else
              {await FirebaseFirestore.instance.collection(collectionname)
                .doc(stockname).set(json);}
              }

        });
    } catch (e) {
        // If any error
        final jsondata = {
                'date': Timestamp.now(),
                'name': stockname,
                'symbol': symbol ,
                'noofshares': noofshares,
                'buyprice': buyprice
              };
              await FirebaseFirestore.instance.collection(collectionname)
                .doc(stockname).set(jsondata);
    }
}

class TransHis{
  final Timestamp? date;
  final String? name;
  final num? netamount;
  final num? noofshares;
  final num? sellprice;
  final String? transactiontype;

  TransHis({required this.date, required this.netamount, required this.noofshares,
    required this.sellprice, required this.transactiontype, required this.name});

  static TransHis fromJson(Map<String, dynamic> json) => TransHis(
      netamount: json['netamount'],
      name: json['name'],
      date: json['date'],
      noofshares: json['noofshares'],
      sellprice: json['sellprice'],
      transactiontype: json['transactiontype']
  );
}

class User{
  final Timestamp date;
  final num buyprice;
  final num stockvol;
  final String name;
  final String symbol;

  User({required this.name, required this.stockvol, required this.buyprice,
    required this.date, required this.symbol});

  static User fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    date: json['date'],
    buyprice: json['buyprice'],
    stockvol: json['noofshares'],
    symbol: json['symbol']
  );
}
