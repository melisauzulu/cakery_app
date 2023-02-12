//When retrieving and displaying an information from a firestore to the homepage
//1- We have to create a model class of the menus infos in order to retrieve and display menus from all the sellers-->menus.dart
//2- Create a design-->info_design.dart
//3- Write a query and display the information-->home_screen.dart

//This class is for 1.

import 'package:cloud_firestore/cloud_firestore.dart';

class Menus{

String? menuID;
String? sellerUID;
String? menuTitle;
String? menuInfo;
Timestamp? publishedDate;
String? thumbnailUrl;
String? status;

Menus({

this.menuID,
this.sellerUID,
this.menuTitle,
this.menuInfo,
this.publishedDate,
this.thumbnailUrl,
this.status,

});

Menus.fromJson(Map<String, dynamic> json){

  menuID = json["menuID"];
  sellerUID = json["sellerUID"];
  menuTitle = json["menuTitle"];
  menuInfo = json["menuInfo"];
  publishedDate = json["publishedDate"];
  thumbnailUrl = json["thumbnailUrl"];
  status = json["status"];

}

Map<String, dynamic>toJson(){
  
  final Map<String, dynamic> data= Map<String,dynamic>();
  data["menuID"]= menuID;
  data["sellerUID"]= sellerUID;
  data["menuTitle"]= menuTitle;
  data["menuInfo"]= menuInfo;
  data["publishedDate"]= publishedDate;
  data["thumbnailUrl"]= thumbnailUrl;
  data["status"]= status;

  return data;
  
}

}