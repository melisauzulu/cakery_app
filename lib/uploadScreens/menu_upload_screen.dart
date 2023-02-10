import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';





class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({Key? key}) : super(key: key);

  @override
  _MenusUploadScreenState createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

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


  @override
  Widget build(BuildContext context) {
    return defaultScreen();
  }
}
