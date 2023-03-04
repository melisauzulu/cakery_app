import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/model/items.dart';
import 'package:cakery_repo/splashScreen/splash_screen.dart';
import 'package:cakery_repo/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


//user item screenden item detail screene
// geçiş yapıyor herhangi itema bastığında
class ItemDetailScreen extends StatefulWidget
{
  final Items? model;
  ItemDetailScreen({this.model});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}




class _ItemDetailScreenState extends State<ItemDetailScreen>
{
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID){
    FirebaseFirestore.instance
        .collection("sellers").doc(sharedPreferences!.getString("uid"))
        .collection("menus")
        .doc(widget.model!.menuId!)
        .collection("items")
        .doc(itemID)
        .delete().then((value){
          FirebaseFirestore.instance.collection("items").doc(itemID).delete();
          
          
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
          Fluttertoast.showToast(msg: "Item Deleted Succesfully ! ");
          
          
    });

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString("name"),),
      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //seçilen itemın image'ı yerleştirildi

            Image.network(widget.model!.thumbnailUrl.toString()),

            //item counter


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.price.toString() + " €" ,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),

           const SizedBox(height: 10,),

           Center(
             child: InkWell(
               onTap: () {

                 //delete item

                 deleteItem(widget.model!.itemID!);


               },
               child: Container (
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

                 width: MediaQuery.of(context).size.width - 13,
                 height: 50,
                 child: const Center(
                   //Add to cart button
                   child: Text(
                     "Delete this item",
                     style: TextStyle(color: Colors.pink, fontSize: 15),
                   ),
                 ),


               ),

             ),
           ),

          ],
        ),
      ),
    );
  }
}
