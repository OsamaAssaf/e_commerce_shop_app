import 'package:flutter/material.dart';
import 'package:osama_shop/widgets/wish_and_bag.dart';


class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  static const String pageRoute = '/wishlist_screen';

  @override
  Widget build(BuildContext context) {

    return const WishBag(appBarTitle: 'Wishlist',icon: Icons.favorite_border_sharp,title: 'It is empty here.',isBag: false,);
  }
}
