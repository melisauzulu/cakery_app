import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/model/menus.dart';
import 'package:cakery_repo/uploadScreens/items_upload_screen.dart';
import 'package:cakery_repo/uploadScreens/menu_upload_screen.dart';
import 'package:cakery_repo/widgets/items_design.dart';
import 'package:cakery_repo/widgets/my_drawer.dart';
import 'package:cakery_repo/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/items.dart';
import '../widgets/info_design.dart';
import '../widgets/progress_bar.dart';


class ItemsScreen extends StatefulWidget {

  final Menus? model; //this screen depends on model
  ItemsScreen({ this.model}); 

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {


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
          style: TextStyle(fontSize: 25, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          
          // whenever you want to add a button or a text widget at the right side of an appBar in flutter,
          // the news basically this atciton

          IconButton(
            icon: Icon(Icons.library_add, color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=>  ItemsUploadScreen(model: widget.model)));
            },
          ),
          
          
        ],
        ),
   drawer: MyDrawer(),
    body:CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned:true,
          delegate: TextWidgetHeader(title: " "+ widget.model!.menuTitle.toString() +" " )),
        StreamBuilder <QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("sellers")
              .doc(sharedPreferences!.getString("uid"))
              .collection("menus")
              .doc(widget.model!.menuID)
              .collection("items")
              .orderBy("publishDate", descending: true) //item sıralaması yeniden eskiye
              .snapshots(),

          builder: ((context, snapshot) {

            return !snapshot.hasData //if data not exists
                ? SliverToBoxAdapter(
              child:Center(child:circularProgress()),

            )
                : SliverStaggeredGrid.countBuilder(
              crossAxisCount: 1,
              staggeredTileBuilder: (c) => StaggeredTile.fit(1),
              itemBuilder: (context,index){

                Items model = Items.fromJson(

                  snapshot.data!.docs[index].data()! as Map<String, dynamic>,

                );
                return ItemsDesignWidget(
                  model:model,
                  context: context,
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          }),
        ),


      ],)
   
   
    );
  }
}