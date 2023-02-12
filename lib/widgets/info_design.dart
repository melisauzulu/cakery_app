import 'package:cakery_repo/mainScreens/itemsScreen.dart';
import 'package:cakery_repo/model/menus.dart';
import 'package:flutter/material.dart';



class InfoDesignWidget extends StatefulWidget {//this class will recieve these 2 parameters
 
Menus? model;
BuildContext? context;

InfoDesignWidget({this.model, this.context});



  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
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
          height:300,
          width: MediaQuery.of(context).size.width,
          child:Column(
            children: [
              Divider(

                height: 4,
                thickness: 3,
                color:Colors.pink[100],


              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height:250,
                fit:BoxFit.cover,
      
              ),


              const SizedBox(height: 10.0,),
              Text(
                widget.model!.menuTitle!,
                style:const TextStyle(
                  color:Colors.black,
                  fontSize:20,
                  fontFamily: "Kiwi",
                   )),

                   Divider(

                height: 4,
                thickness: 3,
                color:Colors.pink[100],


              ),
              Text(
                widget.model!.menuInfo!,
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
