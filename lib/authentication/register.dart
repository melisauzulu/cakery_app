import 'dart:io';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/mainScreens/home_screen.dart';
import 'package:cakery_repo/widgets/custom_text_field.dart';
import 'package:cakery_repo/widgets/error_dialog.dart';
import 'package:cakery_repo/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile; // register sayfasında resim yüklememizi saglayan kısım
  final ImagePicker _picker= ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;
  String sellerImageUrl = "";
  LocationPermission? permission; // !!!!!!!! ÖNEMLİ
  String completeAddress = "";


  Future<void> _getImage() async{

    imageXFile=await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  ////////////////////// BU KOD DA KULLANILABİLİR fakat sorun çıkartmaktadır!!!!
/*
  getCurrentLocation() async{

    permission = await Geolocator.requestPermission(); // BU KOD ÇOK ÖNEMLİ REQUEST'DE BULUNMAMAIZ GEREK KONUM İÇİN
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    // make sure to wear the national sign here, since
    // we have the blessed mark and the corrected location
    Placemark pMark = placeMarks![0];

    // we have to get the address, the textual address from the
    // correct position

    // this is our address
    String completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;

  }

*/
  // get my current location bölümünü ayarladıgımız kısım
  // yukarıya importları eklemeyi unutma
  // bu eklemeleri yapmadan önce google'dan: pub dev sayfasını kullandık
  // geocoding ve geolocator kütüphanelerini import ettik !!
  // farklı bir kod tasarımı kullanılmıştır !!

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

     completeAddress =
        '${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async{ //runs when user clicks on sign up button
    if(imageXFile == null){
      showDialog(
          context: context,
          builder: (c){
            return ErrorDialog(
              message: "Please select an image ! ",
            );
          }
      );
    }
    else{
      if(passwordController.text == confirmpasswordController.text){


        // comfirm passwordunu doğrulama kısmını boş olmamasını kontrol ediyoruz
        if(confirmpasswordController.text.isNotEmpty && emailController.text.isNotEmpty && nameController.text.isNotEmpty && phoneController.text.isNotEmpty && locationController.text.isNotEmpty ){
          //start uploading image
          showDialog(
              context: context,
              builder: (c){
                return LoadingDialog(
                  message: "Registering account",

                );

              }
              );

              // after successfully uploading the image to the storage basically it gives us a download URL
              // and we serve that we assign that download URL to our seller
              String fileName = DateTime.now().millisecondsSinceEpoch.toString();
              fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("sellers").child(fileName);
              fStorage.UploadTask uploadTask= reference.putFile(File(imageXFile!.path));
              fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
              await taskSnapshot.ref.getDownloadURL().then((url){
                sellerImageUrl=url;

                // save info to firestore

                authenticateSellerAndSignUp();


          });



        }
        else{
          showDialog(
              context: context,
              builder: (c){
                return ErrorDialog(
                  message: "Please werite the complete required info for Registration ! ",
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
                message: "Password do not match ! ",
              );
            }
        );

      }

    }
  }

  void authenticateSellerAndSignUp() async{
    //creates user ID and password inside the Firebase authentication

    User? currentUser;
    // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    // bu global.dart'ın içinde tanımlandığı için burdan sildik
    
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
       password: passwordController.text.trim(),
       ).then((auth) {

          currentUser= auth.user;

       }).catchError((error){
          Navigator.pop(context);
           showDialog(
            context: context,
            builder: (c){
              return ErrorDialog(
                message: error.message.toString(),
              );
            }
        );


       });

       if(currentUser != null){
        saveDataToFirestore(currentUser!).then((value) {

          Navigator.pop(context);
          //send user to home page
          Route newRoute= MaterialPageRoute(builder: (c) => HomeScreen());
          Navigator.pushReplacement(context, newRoute);

        });
       }



  }

  Future saveDataToFirestore(User currentUser) async{
    // this function basically we will pass user reviews from Firebase


    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({

      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvatarUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,

    });

      //saving the data locally
      sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences!.setString("uid", currentUser.uid);
      await sharedPreferences!.setString("email", currentUser.email.toString());
      await sharedPreferences!.setString("name", nameController.text.trim());
      await sharedPreferences!.setString("photoUrl", sellerImageUrl);

  }




// enable false olunca, bosluklara yazi yazilmiyor herhangibir sey
  @override
  Widget build(BuildContext context) {
    // Sign up sayfasinda resim ayarlanan kisim
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 15,),
            InkWell(
              onTap: (){
                // sign up sayfasında resim seçtiren kısım
                _getImage();
              },
              child: CircleAvatar(

                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile==null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile == null?
                Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.grey,
                ) : null

              ),
            ),
            const SizedBox(height: 15,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Bakery Name",
                    isObsecre: false,

                  ),
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
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmpasswordController,
                    hintText: "Confirm Password",
                    isObsecre: true,

                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecre: false,

                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: "Bakery Address",
                    isObsecre: false,
                    enabled: false,
                  ),
                  Container(
                    // get my location butonunun ayarlandıgı kısım
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get My Current Location",
                        style:TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: () {

                        // get current location fonksiyonununu çagırdımız kısım
                        getCurrentLocation();


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15,),
            ElevatedButton(
              // bu kısımda flutter kendi düzenleme yaptı satırların yeri degisik gelebilir ayni kod
              //sadece karmaşa olmasın diye flutter düzenledi
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink[300],
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: (){
                formValidation();

              },
              child: const Text(
                "Sign Up",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
              ),
            ),
            const SizedBox(height: 15,), // sign up butonu çok aşağıdaydı bu satırı ekledim
          ],
        ),
      ),
    );

  }
}
