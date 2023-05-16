import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  //creating instance of item

  String? menuId;
  String? sellerUID;
  String? itemID;
  String? title;
  String? shortInfo;
  Timestamp? publishDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  String? serving;
  String? selectedFlavor;
  String? selectedTopping;
  String? selectedOrderType;
  String? responseMessage;
  int? quantity;

  Items({
    this.menuId,
    this.sellerUID,
    this.itemID,
    this.title,
    this.shortInfo,
    this.publishDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,

    this.serving,
    this.selectedFlavor,
    this.selectedTopping,
    this.selectedOrderType,
    this.responseMessage,
    this.quantity
  });

  Items.fromJson(Map<String, dynamic> json)
  {
    menuId = json['menuID'];
    sellerUID = json['sellerUID'];
    itemID = json['itemID'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishDate = json['publishDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    serving = json['serving'];
    selectedFlavor = json['selectedFlavor'];
    selectedTopping = json['selectedTopping'];
    selectedOrderType = json['selectedOrderType'];
    responseMessage = json['responseMessage'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['menuID'] = menuId;
    data['sellerUID'] = sellerUID;
    data['itemID'] = itemID;
    data['title'] = title;
    data['shortInfo'] = shortInfo;
    data['price'] = price;
    data['publishDate'] = publishDate;
    data['thumbnailUrl'] = thumbnailUrl;
    data['longDescription'] = longDescription;
    data['status'] = status;
    data['selectedFlavor'] = selectedFlavor;
    data['selectedTopping'] = selectedTopping;
    data['selectedOrderType'] = selectedOrderType;
    data['responseMessage'] = responseMessage;
    data['quantity'] = quantity;

    return data;
  }




}