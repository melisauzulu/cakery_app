import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/itemsScreen.dart';
import 'package:cakery_repo/model/menus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


//deneme
class InfoDesignWidget extends StatefulWidget {//this class will recieve these 2 parameters



Menus? model;
BuildContext? context;

InfoDesignWidget({this.model, this.context});



  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {

  deleteMenu(String menuID){

    FirebaseFirestore.instance.collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(menuID)
        .delete();

    Fluttertoast.showToast(msg: "Menu Deleted Succesfully");
  }



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:(() {
        
        Navigator.push(context, MaterialPageRoute(builder: (c)=> ItemsScreen(model: widget.model) ));


      }) ,

      splashColor: Colors.pink[50],
      child:Padding(
        padding: const EdgeInsets.all(5.0), //bakeryler arası mesafe
        child: Container(
          height:340,
          width: MediaQuery.of(context).size.width,
          //child:SingleChildScrollView( // BU SATIR KALSIN LAZIM OLABİLİR SİLME !!
            child: Column(
              children: [
                Divider(

                  height: 4,
                  thickness: 3,
                  color:Colors.pink[100],


                ),
                Image.network(
                  widget.model!.thumbnailUrl!,
                  height:260,
                  fit:BoxFit.cover,
      
                ),


                const SizedBox(height: 1.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.model!.menuTitle!,
                      style:const TextStyle(
                        color:Colors.black,
                        fontSize:18,
                        fontFamily: "Kiwi",
                         ),
                    ),
                    IconButton(
                        icon: const Icon(
                          Icons.delete_sweep,
                          color: Colors.pink,
                        ),
                      onPressed: (){
                          //delete menu
                        deleteMenu(widget.model!.menuID!);
                      },
                    ),
                  ],
                ),
                // Text( // Bu kısım kaldırılabilir menu itemsın altındaki açıklamaları temsil ediyor
                 // widget.model!.menuInfo!,
                 // style:const TextStyle(
                  //  color:Colors.black,
                   // fontSize:13,
                    //fontFamily: "Kiwi",
            //         ),

          //      ),
                Divider(

                  height: 4,
                  thickness: 3,
                  color:Colors.pink[100],


                ),


              ],),
          //) single scroll view a bağlı belki lazım olabilir kalsın SİLMEYİN
          
          
           ),

        
        
        ),
    );
  }
}
