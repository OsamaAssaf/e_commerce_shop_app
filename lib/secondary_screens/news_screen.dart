import 'package:flutter/material.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'auth_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogging = context
        .watch<Auth>()
        .user != null;
    return Scaffold(
      appBar: AppBar(
        title:  Text('News',style: Theme.of(context).textTheme.headline3,),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        foregroundColor: Colors.black,
      ),
      body: !isLogging ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list_alt_outlined,size: 128),
            Text('Access all messages after logging in',style: Theme.of(context).textTheme.bodyText1,),
            const SizedBox(height: 8.0,),
            ElevatedButton(
              child: const Text(
                'SIGN IN',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero))),
              onPressed: () async{
                Navigator.of(context).push(PageTransition(
                    child: const AuthScreen(),
                    type: PageTransitionType.rightToLeft));
              },
            ),
          ],
        ),
      )
          : Container(),
    );
  }
}
