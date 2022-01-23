import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:const Icon(Icons.arrow_back_ios),
      onPressed: (){
        Navigator.of(context).pop();
      },
    );
  }
}
