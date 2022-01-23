import 'package:flutter/material.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({Key? key}) : super(key: key);

  static const String pageRoute = '/terms_conditions_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title:const Text('Terms & Conditions'),
        leading: InkWell(
          child:const Icon(Icons.arrow_back_ios),
          onTap: (){
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
