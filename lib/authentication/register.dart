import 'dart:io';

import 'package:cakery_repo/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

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
  LocationPermission? permission; // !!!!!!!! ÖNEMLİ


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

    String completeAddress =
        '${pMark.thoroughfare}, ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea}, ${pMark.country}';

    locationController.text = completeAddress;
  }


// enable false olunca yazi yazilmiyor bosluklara herhangibir sey
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
                        backgroundColor: Colors.teal,
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
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              onPressed: ()=> print("clicked"),
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
