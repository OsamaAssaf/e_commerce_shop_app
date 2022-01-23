import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:osama_shop/account_screens/edit_profile.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/controllers/push_screens.dart';
import 'package:osama_shop/secondary_screens/account_screen.dart';
import 'package:osama_shop/secondary_screens/auth_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String pageRoute = '/settings_screen';

  @override
  Widget build(BuildContext context) {
    String name = '';
    User? user = context.read<Auth>().user;
    if(user != null){
      if(context.read<Auth>().user!.email != null){
        name = context.watch<Auth>().user!.email!.split('@')[0];
      }else{
        name = context.watch<Auth>().user!.phoneNumber!;
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',style: Theme.of(context).textTheme.headline3,),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon:const Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 10.0,),
            if(context.watch<Auth>().user == null)
            boldListTile(context,'SIGN IN / REGISTER',(){Navigator.of(context).push(PageTransition(
                  child: const AuthScreen(),
                  type: PageTransitionType.rightToLeft));}),
            if(user != null)
              boldListTile(context, name, () => PushScreens.pushScreens(context,const EditProfileScreen())),
            const Divider(thickness: 10.0,),
            normalListTile2(context,'Address Book',(){Navigator.of(context).push(PageTransition(
                child: const AuthScreen(),
                type: PageTransitionType.rightToLeft));}),
            const Divider(),
            normalListTile2(context,'My Payment Options',(){Navigator.of(context).push(PageTransition(
                child: const AuthScreen(),
                type: PageTransitionType.rightToLeft));}),
            if(context.watch<Auth>().user != null)
            const Divider(),
            if(context.watch<Auth>().user != null)
            normalListTile2(context,'Account security',(){
              PushScreens.pushScreens(context,const AccountScreen());
            }),
            const Divider(thickness: 10.0,),
            normalListTile2(context,'Country/Region',(){}),
            const Divider(),
            normalListTile2(context,'Language',(){}),
            const Divider(),
            normalListTile2(context,'Currency',(){}),
            const Divider(),
            normalListTile2(context,'Content Preferences',(){}),
            const Divider(),
            normalListTile2(context,'Clear Cache',(){}),
            const Divider(thickness: 10.0,),
            normalListTile2(context,'Rating & Feedback',(){}),
            const Divider(),
            normalListTile2(context,'Connect to Us',(){}),
            const Divider(),
            normalListTile2(context,'About Osama Shop',(){}),
            const Divider(),
            Container(
              width: double.infinity,
              height: 75,
              color: Colors.grey[300],
              child: Center(
                child: Text('Version 0.0.1',style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.normal),),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile boldListTile(BuildContext context,String title,Function() onTap) {
    return ListTile(
            title: Text(title,style: Theme.of(context).textTheme.bodyText2,),
            trailing:const Icon(Icons.arrow_forward_ios,size: 18.0,),
            onTap:onTap,
          );
  }
  ListTile normalListTile2(BuildContext context,String title,Function() onTap) {
    return ListTile(
      title: Text(title,style: Theme.of(context).textTheme.headline4,),
      trailing:const Icon(Icons.arrow_forward_ios,size: 18.0,),
      onTap:onTap,
    );
  }
}
