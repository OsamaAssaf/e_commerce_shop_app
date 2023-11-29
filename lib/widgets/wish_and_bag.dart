import 'package:flutter/material.dart';
import 'package:osama_shop/secondary_screens/auth_screen.dart';
import 'package:page_transition/page_transition.dart';

class WishBag extends StatelessWidget {
  const WishBag(
      {Key? key,
      required this.icon,
      required this.appBarTitle,
      required this.title,
      this.subtitle,
      required this.isBag})
      : super(key: key);

  final IconData icon;
  final String appBarTitle;
  final String title;
  final String? subtitle;
  final bool isBag;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          appBarTitle,
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        actions: [
          if (!isBag)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                splashRadius: 20.0,
                onPressed: () {},
              ),
            ),
        ],
        leading: IconButton(
          icon: Icon(isBag ? Icons.close : Icons.arrow_back_ios),
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
              SizedBox(
                width: width,
                height: height * 0.35,
                child: Column(
                  children: [
                    SizedBox(
                      height: isBag ? height * 0.4 * 0.1 : height * 0.4 * 0.15,
                    ),
                    Icon(
                      icon,
                      size: 64.0,
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    if (isBag)
                      const SizedBox(
                        height: 16.0,
                      ),
                    if (isBag)
                      Text(
                        subtitle!,
                        style: TextStyle(color: Colors.grey[700], fontSize: 20),
                      ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: width * 0.30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(PageTransition(
                              child: const AuthScreen(), type: PageTransitionType.rightToLeft));
                        },
                        child: const FittedBox(
                          child: Text(
                            'Sign in /Register',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    SizedBox(
                      width: width * 0.30,
                      child: TextButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(color: Colors.grey))),
                        ),
                        onPressed: () {},
                        child: const FittedBox(
                          child: Text(
                            'Shop Now',
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
