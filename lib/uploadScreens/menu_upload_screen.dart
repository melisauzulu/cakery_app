import 'dart:io';

import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/home_screen.dart';
import 'package:cakery_repo/widgets/error_dialog.dart';
import 'package:cakery_repo/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;




class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  _MenusUploadScreenState createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();


  defaultScreen(){
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
        title: const Text(
          // sellerın yeni menü eklemesini sağlıyor
          "Add New Menu",
          style: TextStyle(fontSize: 25, fontFamily: "Lobster"),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey,
                Colors.white,
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(2.0, 2.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // menu iconunun değiştirildiği yer
              const Icon(Icons.menu_book, color: Colors.white, size: 200.0,),
              ElevatedButton(
                child: const Text(
                  "Add New Menu",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                style: ButtonStyle(

                  backgroundColor: MaterialStateProperty.all<Color>(Colors.pink),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),


                ),
                onPressed: () {

                  takeImage(context);
                },
              ),
            ],
          ),
        ),
      ),
    );

  }
  takeImage(mContext){

    return showDialog(context: mContext,
    builder: (context){
      return  SimpleDialog(
        title: const Text("Menu Image", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),),
      children: [
        SimpleDialogOption(
          onPressed: CaptureImageWithCamera,
          child: const Text(
            "Capture with Camera",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SimpleDialogOption(
          onPressed: pickImageFromGallery,
          child: const Text(
            "Select from Gallery",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SimpleDialogOption(
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: ()=> Navigator.pop(context),
        ),



      ],
      );
    },


    );
  }
  CaptureImageWithCamera() async {

    Navigator.pop(context);
    imageXFile=await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;

    });


  }
  pickImageFromGallery() async {

    Navigator.pop(context);
    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;

    });

  }

  menusUploadFormScreen(){
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
          title: const Text(
            // sellerın yeni menü eklemesini sağlıyor
            "Uploading New Menu",
            style: TextStyle(fontSize: 15, fontFamily: "Lobster"),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: (){


              clearMenusUploadForm();
            },
          ),
          actions: [
            TextButton(
                child: const Text(
                  // add butonuna tıkladığımızda yapabileceğimiz aksiyonları gösterdiğimiz kısım
                 "Add",
                 style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                   fontSize: 18,
                   fontFamily: "Varela",
                   letterSpacing: 3,
                 ),
                ),
              onPressed: uploading ? () => Fluttertoast.showToast(msg: "You ar already uploading!!") : ()=> validateUploadForm(),
              // we are cheking that if uploading is true there and doing nothing means nothing else do validateUploadForm
            ),
          ],
        ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                          File(imageXFile!.path)
                      ),
                      fit: BoxFit.cover,
                    )
                  ),
                ),
              ),
            ),
          ),
          const Divider(
            // çizgi ekler araya
            color: Colors.pink,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.white,),
            title: Container(
              width: 250,
              child: TextField(
                // menu bilgisinin girildiği kısım
                style: const TextStyle(color: Colors.black),
                controller: shortInfoController,
                  decoration: const InputDecoration(
                    hintText: "Menu info",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),

              ),
          ),
          ),
          const Divider(
            // çizgi ekler araya
            color: Colors.pink,
            thickness: 1,
          ),

          ListTile(
            leading: const Icon(Icons.title, color: Colors.white,),
            title: Container(
              // menu adının girildiği kısım
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Menu title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),

              ),
            ),
          ),
          const Divider(
            // çizgi ekler araya
            color: Colors.pink,
            thickness: 1,
          ),
        ],
      ),


    );
  }

  clearMenusUploadForm(){

    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
      uploading = false;
    });

  }
  validateUploadForm() async{
    setState(() {
      uploading = true;
    });
    if(imageXFile != null){

      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty){

        setState(() {
          uploading = true;
        });
        // upload image
         String downloadURL = await uploadImage(File(imageXFile!.path));
        // save info to firebase
        saveInfo(downloadURL);

      }
      else{
        showDialog(
            context: context,
            builder: (c){
              return ErrorDialog(
                // eğer title ve info girmezse bu hata çıkıcak
                message: "Please write title and info for Menu" ,
              );
            }
        );

      }

    }
    else{
      showDialog(
          context: context,
          builder: (c){
            return ErrorDialog(
              // eğer bir fotoğraf yüklemezse menüye bu hata çıkıcak
              message: "Please pick an picture for Menu" ,
            );
          }
      );


    }

  }

  saveInfo(String downloadUrl){ //saving menu information to database at this reference

    final ref = FirebaseFirestore.instance
    .collection("sellers").doc(sharedPreferences!.getString("uid")).collection("menus");

    ref.doc(uniqueIdName).set({

      "menuID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.toString(),
      "menuTitle": titleController.text.toString(),
      "publishDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,

    });

    clearMenusUploadForm();
    Fluttertoast.showToast(msg: "Menu Created Succesfully");
    setState(() {
      
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;

    });

  }

  uploadImage(mImageFile) async{
    // WE cleared a reference to infer storage and inside the menus folder
    // we want to put our file, reference to our child
    //we serve that reference and references to the menus
    // we have to basically get the download, which we cant get using the task snapshot
    // we implement that and using the task snapshot, we get the download URL of the uploaded image
    //and then we return the download URL
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("menus");
    storageRef.UploadTask uploadTask= reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;

  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
