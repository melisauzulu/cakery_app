import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget with PreferredSizeWidget{

  String? title;
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom,this.title});

  @override
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {


    return  AppBar(
      iconTheme: const IconThemeData(
        // geri gitme tuşunun rengi adrres screen ekranında
        color: Colors.white,
      ),
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
            tileMode: TileMode.clamp, ),
        ),
      ) ,
      centerTitle: true,

      title: Text(

        // sellerın ismini top bar kısımına yazdırıyoruz
        title!,
        style: const TextStyle(fontSize:36, letterSpacing: 3,color: Colors.white ,fontFamily: "Signatra"),
      ),
    );
  }
}
