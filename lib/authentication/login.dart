import 'package:cakery_repo/authentication/auth_screen.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/home_screen.dart';
import 'package:cakery_repo/widgets/custom_text_field.dart';
import 'package:cakery_repo/widgets/error_dialog.dart';
import 'package:cakery_repo/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidaton(){

      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){ //login
 
        loginNow();

      }
      else{
        showDialog(
          context: context,
           builder: (c){

              return ErrorDialog(
                message: "Please write e-mail and password to login.");

           } );
      }

  }

  loginNow()async{

 showDialog(
          context: context,
           builder: (c){

              return LoadingDialog(
                message: "Checking e-mail and password information.");

           } );
      User? currentUser;
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
         password: passwordController.text.trim()).then((auth){
           currentUser= auth.user!;

         } ).catchError((error){

            Navigator.pop(context);

         showDialog(
          context: context,
           builder: (c){

              return ErrorDialog(
                message: error.message.toString());

           } );
         });
         if(currentUser!=null){
           //if user is authenticated sucessfully send user to home screen
            readDataAndSetDataLocally(currentUser!);

         }
  }

  //after login-we store data in local storage instead of retrieving from firestore again and again
  //unless seller logout
  Future readDataAndSetDataLocally(User currentUser) async { 

    await FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).get().then((snapshot) async{

      if(snapshot.exists) { // if this exists, we can save the data locally for the following key
        // then we are going to send the seller inside the app that is to the home screen

        if(snapshot.data()!["status"] == "approved"){
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
          await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
          await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
        }

        else{
          firebaseAuth.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Admin has blocked your account. \n\n Please contact via e-mail address: admin1@cakery.com");

          
        }


      }
      // if no record found, will simply direct the seller to the login sign form
      else{

        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));

        showDialog(
            context: context,
            builder: (c){
              // kullanıcı seller account yerine  sellerdan farklı başka kullanıcı account
              // girişli mail adresi girerse sistem bu hatayı verecek !!
              return ErrorDialog( message: "No record found ! ");

            } );
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                  "images/seller.png",
                height: 290,

              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),

              ],
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
            // bu kısımda flutter kendi düzenleme yaptı satırların yeri degisik gelebilir ayni kod
            //sadece karmaşa olmasın diye flutter düzenledi
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink[300],
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            ),


            onPressed: (){

            formValidaton();





            },

            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
          ),
        ],

      ),
    );
  }
}
