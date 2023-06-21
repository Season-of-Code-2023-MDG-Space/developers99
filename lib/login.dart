import 'package:flutter/material.dart';
import 'package:trading_app/Services/firebaseauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trading_app/Services/localstorage.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);
  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  initState(){
    super.initState();
    _emailTextController.text = UserSharedPreferences.getEmail() != null ? UserSharedPreferences.getEmail() : '';
    _passwordTextController.text = UserSharedPreferences.getPassword() != null ? UserSharedPreferences.getPassword() : '';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login.jpg'),
          fit: BoxFit.fitHeight
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: initializeFirebase(),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.done)
            {return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left:35.0, top: 130),
                  child: const Text(
                    'Welcome\nBack',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 33
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height*0.5,
                        right: 35.0,
                        left: 35.0,
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailTextController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
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
                          obscureText: true,
                          controller: _passwordTextController,
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
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
                          children: [
                            const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 27.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white70,
                              child: IconButton(
                                onPressed: () async{
                                  User? user = await FireAuth.signInUsingEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                    context: context
                                  );
                                  if (user != null) {
                                    UserSharedPreferences.setEmail(_emailTextController.text);
                                    UserSharedPreferences.setUserName(_emailTextController.text);
                                    Navigator.of(context)
                                        .pushNamed('home');
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
                                Navigator.pushNamed(context,'register');
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const TextButton(
                              onPressed: null,
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 18.0,
                                  color: Colors.white,
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
            );}
            else{
              return const Center(
            child: CircularProgressIndicator(),
          );
            }
          }
        ),
      ),
    );
  }
}
