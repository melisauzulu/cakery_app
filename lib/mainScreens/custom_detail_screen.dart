import 'dart:math';

import 'package:cakery_repo/model/address.dart';
import 'package:cakery_repo/widgets/progress_bar.dart';
import 'package:cakery_repo/widgets/shipment_address_design.dart';
import 'package:cakery_repo/widgets/status_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../model/items.dart';

class CustomDetailScreen extends StatefulWidget {
  final String? itemID;

  CustomDetailScreen({this.itemID});

  @override
  _CustomDetailScreen createState() => _CustomDetailScreen();
}

class _CustomDetailScreen extends State<CustomDetailScreen> {
  String title = "";
  String shortInfo = "";
  String publishDate = "";
  String responseMessage = "";

  String selectedFlavor = "";
  String selectedOrderType = "";
  String selectedTopping = "";
  String sellerName = "";

  String sellerUID = "";

  String serving = "";

  String status = "";

  String thumbnailUrl = "";
  String customerId = "";
  int price = 0;
  int quantity=0;

  getCustomInfo() {
    FirebaseFirestore.instance
        .collection("items")
        .doc(widget.itemID)
        .get()
        .then((DocumentSnapshot) {
      title = DocumentSnapshot.data()!["title"].toString();
      shortInfo = DocumentSnapshot.data()!["shortInfo"].toString();
      publishDate = DocumentSnapshot.data()!["publishDate"].toString();
      responseMessage = DocumentSnapshot.data()!["responseMessage"].toString();
      selectedFlavor = DocumentSnapshot.data()!["selectedFlavor"].toString();
      selectedOrderType =
          DocumentSnapshot.data()!["selectedOrderType"].toString();
      selectedTopping = DocumentSnapshot.data()!["selectedTopping"].toString();
      sellerName = DocumentSnapshot.data()!["sellerName"].toString();
      sellerUID = DocumentSnapshot.data()!["sellerUID"].toString();
      serving = DocumentSnapshot.data()!["serving"].toString();
      status = DocumentSnapshot.data()!["status"].toString();
      thumbnailUrl = DocumentSnapshot.data()!["thumbnailUrl"].toString();
      price = DocumentSnapshot.data()!["price"];
      quantity = DocumentSnapshot.data()!["quantity"];
    });
  }

  getCustomerInfo() {
    FirebaseFirestore.instance
        .collection("requested_cakes")
        .doc(widget.itemID)
        .get()
        .then((DocumentSnapshot) {
      customerId = DocumentSnapshot.data()!["userID"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    getCustomInfo();
    getCustomerInfo();
  }

  Future<void> updateStatus() async {
    DocumentSnapshot requestedCakeDoc = await FirebaseFirestore.instance
        .collection('requested_cakes')
        .doc(widget.itemID) // Replace with the actual document ID
        .get();

    if (requestedCakeDoc.exists) {
      // Extract the item ID from the document data
      String requestedItemId = (requestedCakeDoc.data()! as Map<String, dynamic>)['itemID'];

      if (requestedItemId == widget.itemID) {
        // Update the status field to "approved"
        await requestedCakeDoc.reference.update({'status': 'approved'});
        print('Status updated successfully!');
      }
      
    } else {
      print('requested_cakes document does not exist.');
    }
  }
   Future<void> declineStatus() async {

      DocumentSnapshot requestedCakeDoc = await FirebaseFirestore.instance
        .collection('requested_cakes')
        .doc(widget.itemID) // Replace with the actual document ID
        .get();
         await requestedCakeDoc.reference.update({'status': 'declined'});
        print('Status updated successfully!');

   }



  Future<void> updateThePrice( int newPrice) async {
    // Get a reference to the document for the item with the specified itemID
    DocumentReference itemRef =
    FirebaseFirestore.instance.collection("items").doc(widget.itemID);

    try {
      // Use a transaction to update the price of the item
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot itemSnapshot = await transaction.get(itemRef);
        if (!itemSnapshot.exists) {
          throw Exception("Item with ID $widget.itemID not found.");
        }
        transaction.update(itemRef, {"price": newPrice});
      });

      print("Price of item with ID $widget.itemID updated to $newPrice.");
    } catch (e) {
      print("Error updating price of item with ID $widget.itemID: $e");
    }
  }




  Future<void> addToUsersCart() async {
    List<String> tempList = ["${widget.itemID}" + ":${quantity}"+":"+"${sellerUID}"];
    // Get a reference to the current user's document in the "users" collection
    DocumentReference userRef =
    FirebaseFirestore.instance.collection("users").doc(customerId);

    try {
      // Update the "userCart" field in the document
      await userRef.update({
        "customCart": FieldValue.arrayUnion(tempList),
      });
      print("User cart updated successfully!");
    } catch (error) {
      print("Failed to update user cart: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("items")
              .doc(widget.itemID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              status = dataMap["status"].toString();
            }
            TextEditingController priceController = TextEditingController();
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        Image.network(
                          thumbnailUrl,
                          height: MediaQuery.of(context).size.height /
                              3, // 1/5 of the screen height
                          width: MediaQuery.of(context)
                              .size
                              .width, // full screen width
                          fit: BoxFit
                              .cover, // adjust the image to fill the container
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Title : " + title!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Customer Note : " + shortInfo!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Selected Serving = " + serving!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Selected Flavor = " + selectedFlavor!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Selected Topping = " + selectedTopping!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Selected Order Type = " + selectedOrderType!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Customer ID = " + customerId!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      /*  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Customer: " + customerId!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Request at: " + publishDate,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),*/
                        const Divider(
                          color: Colors.pink,
                          thickness: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Quantity : " + quantity.toString(),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const Divider(
                          color: Colors.pink,
                          thickness: 4,
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter the price per cake',
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            price = int.parse(value);
                            // Handle the value change
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (price == 0) {
                                  //TODO: print edit price alert
                                  print(" ");
                                } else {
                                  //TODO: add to cart functionalities.
                                  //user user cart list e item ı ekle ve item status ü updatele
                                  print(" ");

                                  addToUsersCart();
                                  updateThePrice(price);
                                  updateStatus();

                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "Custom Cake Request Approved.");


                                }
                              },
                              child: Text("Approve"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // handle decline button press
                                //TODO: Set status as declined
                                declineStatus();

                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "Custom Cake Request Declined.");

                              },
                              child: Text("Decline"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
