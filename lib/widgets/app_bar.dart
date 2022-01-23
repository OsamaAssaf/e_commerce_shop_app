import 'package:flutter/material.dart';

class AppBarWidget{

  static PreferredSizeWidget setNormalAppBar(String title,BuildContext context){
    return AppBar(
      elevation: 0.0,
      title: Text(title),
      bottom:const PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Divider(),
      ),
      leading: IconButton(
        icon:const Icon(Icons.arrow_back_ios),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      foregroundColor: Colors.black,

    );
  }

  static PreferredSizeWidget setCenterAppBar(String title,BuildContext context){
    return AppBar(
      elevation: 0.0,
      title: Text(title,style: Theme.of(context).textTheme.bodyText2,),
      bottom:const PreferredSize(
        preferredSize: Size.fromHeight(10.0),
        child: Divider(thickness: 10,),
      ),
      leading: IconButton(
        icon:const Icon(Icons.arrow_back_ios),
        onPressed: (){
          Navigator.of(context).pop();
        },
      ),
      foregroundColor: Colors.black,
      centerTitle: true,

    );
  }






}
