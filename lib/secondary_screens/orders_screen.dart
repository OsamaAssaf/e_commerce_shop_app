import 'package:flutter/material.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders', style: Theme
            .of(context)
            .textTheme
            .headline3,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        foregroundColor: Colors.black,
      ),
      body: null
    );
  }
}
