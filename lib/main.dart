import 'package:flutter/material.dart';
import 'home.dart';
import 'register.dart';
import 'login.dart';
import 'Presentation/portfolio.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: 'login',
  routes: {
    'login' : (context)=>const MyLogin(),
    'register' : (context)=>const MyRegister(),
    'home' : (context)=>const HomePage(),
    'portfolio' : (context)=>const PortfolioPage(),
  },
));

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
