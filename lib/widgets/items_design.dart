import 'package:cakery_repo/mainScreens/itemsScreen.dart';
import 'package:cakery_repo/model/menus.dart';
import 'package:flutter/material.dart';

import '../model/items.dart';



class ItemsDesignWidget extends StatefulWidget {//this class will recieve these 2 parameters

  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});



  @override
  State<ItemsDesignWidget> createState() => _ItemsDesignWidgetState();
}

class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(() {
        //when seller clicks on it displays spesific item's complete info

        //Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model) ));


      }) ,

      splashColor: Colors.pink[50],
      child:Padding(
        padding: const EdgeInsets.all(5.0), //bakeryler arası mesafe
        child: Container(
            height:300,
            width: MediaQuery.of(context).size.width,
            child:Column(
              children: [
                Divider(
                  height: 4,
                  thickness: 3,
                  color:Colors.pink[100],
                ),

                const SizedBox(height: 20,),

                Text(
                    widget.model!.title!,
                    style:const TextStyle(
                      color:Colors.black,
                      fontSize:18,
                      fontFamily: "Kiwi",
                    )),

                const SizedBox(height: 20,),

                Image.network(
                  widget.model!.thumbnailUrl!,
                  height:250,
                  fit:BoxFit.cover,

                ),


                const SizedBox(height: 20.0,),

                Divider(

                  height: 4,
                  thickness: 3,
                  color:Colors.pink[100],


                ),
                const SizedBox(height: 10,),

                Text(
                    widget.model!.shortInfo!,
                    style:const TextStyle(
                      color:Colors.black,
                      fontSize:20,
                      fontFamily: "Kiwi",
                    )),


              ],)


        ),



      ),
    );
  }
}
