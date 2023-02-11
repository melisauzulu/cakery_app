import 'package:cakery_repo/authentication/auth_screen.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/uploadScreens/menu_upload_screen.dart';
import 'package:cakery_repo/widgets/my_drawer.dart';
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
      drawer: MyDrawer(),

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
          style: TextStyle(fontSize: 25, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          
          // whenever you want to add a button or a text widget at the right side of an appBar in flutter, the news basically this atciton

          IconButton(
            icon: Icon(Icons.post_add, color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MenusUploadScreen()));
            },
          ),
          
          
        ],
        ),

        body:Center(),
    );
  }
}