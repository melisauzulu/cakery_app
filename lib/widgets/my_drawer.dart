import 'package:cakery_repo/authentication/auth_screen.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/earnings_screen.dart';
import 'package:cakery_repo/mainScreens/history_screen.dart';
import 'package:cakery_repo/mainScreens/home_screen.dart';
import 'package:cakery_repo/mainScreens/new_orders_screen.dart';
import 'package:flutter/material.dart';

import '../mainScreens/custom_cake_approval_screen.dart';

class MyDrawer extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //header drawer
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [

                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Train"),
                )
              ],
            ),
          ),

          const SizedBox(height:12),

          //Body Drawer
          // dahsboardda sol taraftan açılan menünün bodysinin tanımlandığı kısım

          Container(

            padding: const EdgeInsets.only(top:1.0),
            child:Column(
              children:[
                const Divider(
                   height:10,
                   color: Colors.pink,
                   thickness: 2,),
                   ListTile(
                    leading:  Icon(Icons.home,color:Colors.pink[500]),
                    title: const Text(
                       "Home",
                       style:TextStyle(color:Colors.black,),

                       ),

                       onTap:(() {
                         Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
                       }) ,
                       
                      
                   ),
                   const Divider(
                   height:10,
                   color: Colors.pink,
                   thickness: 2,),

                    ListTile(
                    leading:  Icon(Icons.monetization_on,color:Colors.pink[500]),
                    title: const Text(
                       "My Earnings",
                       style:TextStyle(color:Colors.black,),

                       ),

                       onTap:(() {
                         Navigator.push(context, MaterialPageRoute(builder: (c) => const EarningsScreen()));
                       }) ,               

                   ),
                   const Divider(
                   height:10,
                   color: Colors.pink,
                   thickness: 2,),

                    ListTile(
                    leading:  Icon(Icons.reorder,color:Colors.pink[500]),
                    title: const Text(
                       "New Orders",
                       style:TextStyle(color:Colors.black,),

                       ),

                       onTap:(() {
                         //For Later

                         Navigator.push(context, MaterialPageRoute(builder: (c) => NewOrdersScreen()));
                       }) ,               

                   ),

                   const Divider(
                   height:10,
                   color: Colors.pink,
                   thickness: 2,),

                ListTile(
                  leading:  Icon(Icons.reorder,color:Colors.pink[500]),
                  title: const Text(
                    "Custom Cake Approval",
                    style:TextStyle(color:Colors.black,),

                  ),

                  onTap:(() {
                    //For Later

                    Navigator.push(context, MaterialPageRoute(builder: (c) => CustomCakesScreen()));
                  }) ,

                ),

                const Divider(
                  height:10,
                  color: Colors.pink,
                  thickness: 2,),

                    ListTile(
                    leading:  Icon(Icons.local_shipping,color:Colors.pink[500]),
                    title: const Text(
                       "History - Orders",
                       style:TextStyle(color:Colors.black,),

                       ),

                       onTap:(() {

                         Navigator.push(context, MaterialPageRoute(builder: (c) => HistoryScreen()));
                       }) ,               

                   ),

                   const Divider(
                   height:10,
                   color: Colors.pink,
                   thickness: 2,),

                    ListTile(
                    leading:  Icon(Icons.exit_to_app,color:Colors.pink[500]),
                    title: const Text(
                       "Sign Out",
                       style:TextStyle(color:Colors.black,),

                       ),

                       onTap:() {

                          firebaseAuth.signOut().then((value) { //allow user to logout

                          Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));

              }); 
                       },
                       ) ,               

                  
                   
                   const Divider(
                   height:10,
                   color: Colors.pink,
                   thickness: 2,),
              
              
              ],
            ),


          ),
        ],
      ),
    );
  }
}
