import 'package:flutter/material.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/secondary_screens/auth_screen.dart';
import 'package:osama_shop/secondary_screens/news_screen.dart';
import 'package:osama_shop/secondary_screens/orders_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({Key? key}) : super(key: key);

  static const String pageRoute = '/message_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          'Message',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: const Icon(Icons.cleaning_services_rounded),
              splashRadius: 20.0,
              onPressed: () {},
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Divider(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  _card(Icons.list_alt_outlined, 'Orders',
                      'Keep updated on the status of orders and login.', context, () {
                    if (context.read<Auth>().user == null) {
                      Navigator.of(context).push(PageTransition(
                          child: const AuthScreen(), type: PageTransitionType.rightToLeft));
                    } else {
                      Navigator.of(context).push(PageTransition(
                          child: const OrdersScreen(), type: PageTransitionType.rightToLeft));
                    }
                  }),
                  _card(Icons.volume_up_outlined, 'News',
                      'Be the first to know website/account update an login.', context, () {
                    Navigator.of(context).push(PageTransition(
                        child: const NewsScreen(), type: PageTransitionType.rightToLeft));
                  }),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              _listTile(Icons.local_fire_department_outlined, 'Osama Shop Gals',
                  'New likes, comments and followers.'),
              _listTile(Icons.check_circle, 'Activities',
                  'Get the latest information of our events and interactive games'),
              _listTile(Icons.local_offer_outlined, 'Promo', 'Don\'t miss out on promotions!'),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _listTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[400],
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      title: Text(title),
      subtitle: Column(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text(subtitle),
          const Divider(),
        ],
      ),
      visualDensity: VisualDensity.compact,
      onTap: () {},
    );
  }

  Expanded _card(
      IconData icon, String title, String subtitle, BuildContext context, Function() onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 30,
                    child: Icon(
                      icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
