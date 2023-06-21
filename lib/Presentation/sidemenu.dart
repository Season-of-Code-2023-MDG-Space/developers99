import 'package:flutter/material.dart';
//import 'package:page_transition/page_transition.dart';
import 'package:trading_app/Presentation/portfolio.dart';
import 'package:trading_app/home.dart';
import 'search.dart';
import 'graph.dart';
import 'package:trading_app/Services/localstorage.dart';

//import 'package:trading_app/main.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(UserSharedPreferences.getUserName()), accountEmail: Text(UserSharedPreferences.getEmail())),
          ListTile(
            //tileColor: Colors.black.withOpacity(0.5),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),
            //side: BorderSide(color: Colors.purple.shade900)),
            tileColor: Colors.white,
            iconColor: Colors.purple.shade900,
            textColor: Colors.purple.shade900,
            contentPadding: EdgeInsets.only(left: 30, right: 50, top: 0),
            leading: Icon(Icons.input),
            title: Text('SEARCH STOCK'),
            onTap: () => {Navigator.of(context).pop(),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()))},
          ),
          ListTile(
            tileColor: Colors.white,
            iconColor: Colors.purple.shade800,
            textColor: Colors.purple.shade800,
            contentPadding: EdgeInsets.only(left: 30, right: 50, top: 10),
            leading: Icon(Icons.account_circle_sharp),
            title: Text('PORTFOLIO'),
            onTap: () => {Navigator.of(context).pop(),
            Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioPage()))},
          ),
          ListTile(
            tileColor: Colors.white,
            iconColor: Colors.purple.shade700,
            textColor: Colors.purple.shade700,
            contentPadding: EdgeInsets.only(left: 30, right: 50, top: 10),
            leading: Icon(Icons.history),
            title: Text('TRANSACTION HISTORY'),
            onTap: () => {Navigator.of(context).pop(),
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()))},
          ),
          ListTile(
            tileColor: Colors.white,
            iconColor: Colors.purple.shade600,
            textColor: Colors.purple.shade600,
            contentPadding: EdgeInsets.only(left: 30, right: 50, top: 10),
            leading: Icon(Icons.show_chart),
            title: Text('LIVE MARKET'),
            onTap: () => {Navigator.of(context).pop(),
            Navigator.push(context, MaterialPageRoute(builder: (context) => graphapp()))},
          ),
          ListTile(
            tileColor: Colors.white,
            iconColor: Colors.purple.shade500,
            textColor: Colors.purple.shade500,
            contentPadding: EdgeInsets.only(left: 30, right: 50, top: 10),
            leading: Icon(Icons.newspaper),
            title: Text('LATEST STOCK NEWS'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            tileColor: Colors.white,
            iconColor: Colors.purple.shade400,
            textColor: Colors.purple.shade400,
            contentPadding: EdgeInsets.only(left: 30, right: 50, top: 10),
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}