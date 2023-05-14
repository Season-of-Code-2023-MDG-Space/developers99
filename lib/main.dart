import 'package:flutter/material.dart';
import 'package:trading_app/Services/firebaseauth.dart';
import 'home.dart';
import 'register.dart';
import 'login.dart';
import 'Presentation/portfolio.dart';
import 'Services/localstorage.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebase();
  await UserSharedPreferences.init();
  String user = '${UserSharedPreferences.getUserName()}';
  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: (user != 'null' && user.length > 0) ? 'login' : 'register',
  routes: {
    'login' : (context)=>const MyLogin(),
    'register' : (context)=>const MyRegister(),
    'home' : (context)=>const HomePage(),
    'portfolio' : (context)=>const PortfolioPage(),
  },
));}

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}