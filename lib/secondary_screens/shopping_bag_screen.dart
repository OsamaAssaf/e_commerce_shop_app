import 'package:flutter/material.dart';
import 'package:osama_shop/widgets/wish_and_bag.dart';


class ShoppingBagScreen extends StatelessWidget {
  const ShoppingBagScreen({Key? key}) : super(key: key);

  static const String pageRoute = '/shopping_bag_screen';


  @override
  Widget build(BuildContext context) {
    return const WishBag(appBarTitle: 'Shopping Bag',icon: Icons.shopping_bag_outlined,title: 'Your bag is empty',subtitle: 'Log in to see shopping cart',isBag: true,);
  }
}
