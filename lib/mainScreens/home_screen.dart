import 'package:cakery_repo/authentication/auth_screen.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
        title: Text(
          // sellerın ismini top bar kısımına yazdırıyoruz
          sharedPreferences!.getString("name")!,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        
        ),

        body:Center(
          
          child: ElevatedButton(
            child: const Text("Logout"),
            style:ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
            ),
            onPressed:(() {
              
              firebaseAuth.signOut().then((value) { //allow user to logout

                Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));

              }); 
              
            } 
             ),
              ),
        ),
    );
  }
}