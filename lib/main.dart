import 'package:flutter/material.dart';
import 'package:trading_app/home.dart';
import 'package:trading_app/register.dart';
import 'login.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: 'login',
  routes: {
    'login' : (context)=>const MyLogin(),
    'register' : (context)=>const MyRegister(),
    'home' : (context)=>const HomePage(),
  },
));

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
