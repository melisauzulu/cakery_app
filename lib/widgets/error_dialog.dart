import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {

  final String? message;
  ErrorDialog({this.message});

// Satıcı kayıt olmaya çalıştığında resm yüklemezse vey şifre doğrulamasını yanlış girerse veya
  // doldurması gerekn alanları doldurmazsa uyarı mesajı çıkmasını sağlayan kısım bu kısım !!

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          child: const Center(
            child: Text("OK"),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          onPressed: (){
              Navigator.pop(context);

          },
        )
      ],
    );
  }
}
