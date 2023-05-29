import 'package:cakery_repo/assistantMethods/assistant_methods.dart';
import 'package:cakery_repo/global/global.dart';
import 'package:cakery_repo/widgets/progress_bar.dart';
import 'package:cakery_repo/widgets/simple_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_card.dart';




class CustomCakesScreen extends StatefulWidget
{
  @override
  _CustomCakesScreen createState() => _CustomCakesScreen();
}



class _CustomCakesScreen extends State<CustomCakesScreen>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "Approval Custom Cakes",),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("requested_cakes")
              .where("status", isEqualTo: "waiting")
              .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
              .snapshots(),
          builder: (c, snapshot)
          {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index)
              {
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("items")
                      .where("itemID", isEqualTo:(snapshot.data!.docs[index].data()! as Map)["itemID"])
                      .orderBy("publishDate", descending: true)
                      .get(),
                  builder: (c, snap)
                  {
                    return snap.hasData
                        ? CustomCard(
                      itemID: snapshot.data!.docs[index].id,
                      itemCount: 1,
                      data: snap.data!.docs,
                      //TODO: add seperateQuantitiesList to here.Quantity diye items modelime seller ve user tarafında yeni bir int eklenmelidir
                      // bu int customer quantity belirmesi ve seller ın da bunu kabul etmesi için gerektiği için lazımdır
                      //eğer customerın custom cake offerını seller kabul ederse o zaman zaten customer da customcarptım da set edilecek olan
                      // quantity value su 43. satırdaki query ile gelebilecektir vu sayede buraya onu direkt koaybilirsiniz.
                      //
                    )
                        : Center(child: circularProgress());
                  },
                );
              },
            )
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
