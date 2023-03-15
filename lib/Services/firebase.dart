import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future createUser({required String name, required String passwor}) async{
  //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final docUser = FirebaseFirestore.instance.collection('user').doc(name);

  final json = {
    'name': name,
    'password': passwor,
  };

  await docUser.set(json);
}

Stream<List<User>> readUserStocks() => FirebaseFirestore.instance
      .collection('UserName') //gets all collection
      //.orderBy('date', descending: true)
      .snapshots()  //gets all documents
      .map((snapshot) =>  //returns a query snapshot of map string dynamic so that we get some json data.
  snapshot.docs.map(((doc) => User.fromJson(doc.data()))).toList()); //first go to each document data then convert json data to user objects   //which gets converted to list data later.

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
    stockvol: json['stockvol'],
      symbol: json['symbol']
  );
}