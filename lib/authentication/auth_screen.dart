import 'package:cakery_repo/authentication/login.dart';
import 'package:cakery_repo/authentication/register.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace:Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.white54,
                      Colors.grey,
                    ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(2.0, 2.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
              ),
            ) ,

            //backgroundColor: Colors.brown,
            automaticallyImplyLeading: false, // remove back button
            title: const Text(
                "Cakery",
              style: TextStyle(
                fontSize: 43,
                color: Colors.white,
                fontFamily: "Lobster",

              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.lock, color: Colors.white,),
                    text: "Login",
                  ),
                  Tab(
                      icon: Icon(Icons.lock, color: Colors.white,),
                      text: "Sign Up" ,
                  ),
                ],
              indicatorColor: Colors.white60,
              indicatorWeight: 4,
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.topLeft,
                  colors: [
                    Colors.black45,
                    Colors.blueGrey,
              ],
              )
            ),
            child: const TabBarView(
              children: [
                LoginScreen(),
                RegisterScreen(),

              ],
            ),
          ),
        ),
    ) ;
  }
}
