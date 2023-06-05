import 'dart:async';

import 'package:cakery_repo/authentication/auth_screen.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}



class _MySplashScreenState extends State<MySplashScreen> {
  
  startTimer(){
    
    Timer(const Duration(seconds: 2),  () async {

      if(firebaseAuth.currentUser != null){ // checks if the user is already logged-in/authenticated or not

      Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen())); //if yes, direct user to homescreen

      }

      else{ //if no, diret user to authscreen

      Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

      }
    });
  }

  @override
  void initState() {
    // this function is called automatically whenever the user comes to their screen
    super.initState();
    startTimer();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset("images/splash.jpg"),
              ),

              const SizedBox(height: 10,),

              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  // Baslik
                  "Cakery For Seller",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                    fontFamily: "Signatra",
                    letterSpacing: 3,
                  ),
                ),
              ),
            ],
          ),

        ),
      )
    );
  }
}
