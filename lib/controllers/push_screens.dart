import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';

class PushScreens{

  static pushScreens(BuildContext context,Widget screen){
    Navigator.of(context).push(PageTransition(
        child: screen,
        type: PageTransitionType.rightToLeft));
  }

}