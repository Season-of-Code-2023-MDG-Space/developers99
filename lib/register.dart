import 'package:flutter/material.dart';
import 'package:trading_app/Services/firebaseauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Services/localstorage.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final _nametextcontroller= TextEditingController();
  final _emailtextcontroller = TextEditingController();
  final _passwordtextcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/register.jpg'),
              fit: BoxFit.fitHeight
          )
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.grey.shade800,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left:35.0, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 33
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.3,
                  right: 35.0,
                  left: 35.0,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _nametextcontroller,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _emailtextcontroller,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: _passwordtextcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                        const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 27.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white70,
                          child: IconButton(
                            onPressed:() async{                              
                                  User? user = await FireAuth.registerUsingEmailPassword(
                                    name: _nametextcontroller.text,
                                    email: _emailtextcontroller.text,
                                    password: _passwordtextcontroller.text,
                                  );
                                  if (user != null) {
                                    Navigator.of(context)
                                        .pushNamed('home');
                                        UserSharedPreferences.setPassword(_passwordtextcontroller.text);
                                        UserSharedPreferences.setUserName(_nametextcontroller.text);
                                        UserSharedPreferences.setEmail(_emailtextcontroller.text);
                                        UserSharedPreferences.setBalance1(200000);
                                        UserSharedPreferences.setBalance2(20000);
                                  }
                                  },
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context,'login');
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
