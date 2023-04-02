import 'package:cakery_repo/authentication/auth_screen.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/model/menus.dart';
import 'package:cakery_repo/splashScreen/splash_screen.dart';
import 'package:cakery_repo/uploadScreens/menu_upload_screen.dart';
import 'package:cakery_repo/widgets/info_design.dart';
import 'package:cakery_repo/widgets/my_drawer.dart';
import 'package:cakery_repo/widgets/progress_bar.dart';
import 'package:cakery_repo/widgets/text_widget_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  restrictBlockedSellerFromUsingApp() async {
    await FirebaseFirestore.instance.collection("sellers")
        .doc(firebaseAuth.currentUser!.uid)
        .get().then((snapshot) {
      if(snapshot.data()!["status"] == "not approved"){

        Fluttertoast.showToast(msg: "You have been blocked !");
        firebaseAuth.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
      }


    });

  }

  @override
  void initState() {

    super.initState();

    restrictBlockedSellerFromUsingApp();
  }




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

        body:CustomScrollView(
          slivers:[
        
            SliverPersistentHeader(pinned:true, delegate: TextWidgetHeader(title: "My Menus")),
            StreamBuilder <QuerySnapshot>(
              stream: FirebaseFirestore.instance
              .collection("sellers")
              .doc(sharedPreferences!.getString("uid"))
              .collection("menus")
              .orderBy("publishDate", descending: true) //menü sıralaması yeniden eskiye
              .snapshots(),

              builder: ((context, snapshot) {

                return !snapshot.hasData //if data not exists
                ? SliverToBoxAdapter(
                  child:Center(child:circularProgress(),),
                
                )
                : SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 1,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemBuilder: (context,index){

                    Menus model = Menus.fromJson(

                      snapshot.data!.docs[index].data()! as Map<String, dynamic>,
                    
                    );
                    return InfoDesignWidget(
                      model:model,
                      context: context,
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                   );
              }),
              ),

          ]




        ),
    );
  }
}