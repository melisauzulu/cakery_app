import 'package:cakery_repo/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {

  final String? message;
  LoadingDialog({this.message});


// yükleme ekranında gösterilecek olan uyarıyı bu kısımda ayarlıyoruz
//sadece login ekranı da değil overall ekranlarda gösterilcek uyarı widgeti
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          SizedBox(height: 10,),
          Text(message! + ", Please wait..."),
        ],
      ),
    );
  }
}
