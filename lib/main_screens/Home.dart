import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:osama_shop/account_screens/profile.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/controllers/push_screens.dart';
import 'package:osama_shop/main_screens/women_screen.dart';
import 'package:osama_shop/secondary_screens/auth_screen.dart';
import 'package:osama_shop/secondary_screens/message_screen.dart';
import 'package:osama_shop/secondary_screens/shopping_bag_screen.dart';
import 'package:osama_shop/secondary_screens/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'beauty_screen.dart';
import 'curve_plus_screen.dart';
import 'home_pets_screen.dart';
import 'kids_screen.dart';
import 'men_screen.dart';

import 'package:page_transition/page_transition.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

import 'settings_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String pageRoute = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late List<PreferredSizeWidget?> appBarWidgets;
  late List<Widget> bodyWidgets;

  late TextEditingController _categorySearchController;
  late TabController _tabController;


  @override
  void initState() {
    _categorySearchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(1);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    appBarWidgets = [
      AppBar(
        title: Text(
          'Osama Shop',
          style: Theme.of(context).textTheme.headline1,
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: const Icon(
                  Icons.email_outlined,
                  color: Colors.black,
                  size: 28,
                ),
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                      child: const MessageScreen(),
                      type: PageTransitionType.rightToLeft));
                },
              ),
              InkWell(
                child: const Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.black,
                  size: 28,
                ),
                onTap: () {
                  Navigator.of(context).push(PageTransition(
                      child: const WishlistScreen(),
                      type: PageTransitionType.rightToLeft));
                },
              ),
            ],
          ),
        ),
        leadingWidth: 100.0,
        actions: [
          const SizedBox(
            width: 16.0,
          ),
          InkWell(
            child: const Icon(
              Icons.search_rounded,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {},
          ),
          const SizedBox(
            width: 12.0,
          ),
          InkWell(
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const ShoppingBagScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
          const SizedBox(
            width: 16.0,
          ),
        ],
        bottom: TabBar(
          labelColor: Colors.black,
          labelStyle: Theme.of(context).textTheme.headline2,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.black,
          indicatorWeight: 2,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          isScrollable: true,
          tabs: const [
            Tab(
              text: 'WOMEN',
            ),
            Tab(
              text: 'KIDS',
            ),
            Tab(
              text: 'CURVE+PLUS',
            ),
            Tab(
              text: 'MEN',
            ),
            Tab(
              text: 'BEAUTY',
            ),
            Tab(
              text: 'HOME+PETS',
            ),
          ],
        ),
      ),
      AppBar(
        title: SizedBox(
          height: 40,
          child: TextField(
            controller: _categorySearchController,
            decoration: InputDecoration(
                fillColor: Colors.grey[200],
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(0.0),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[700],
                ),
                suffixIcon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.grey[700],
                ),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18.0,
                )),
            cursorColor: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: InkWell(
            child: const Icon(
              Icons.email_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const MessageScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
        ),
        leadingWidth: 50.0,
        actions: [
          const SizedBox(
            width: 16.0,
          ),
          InkWell(
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const ShoppingBagScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
          const SizedBox(
            width: 16.0,
          ),
        ],
        bottom: TabBar(
          labelColor: Colors.black,
          labelStyle: Theme.of(context).textTheme.headline2,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.black,
          indicatorWeight: 2,
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          isScrollable: true,
          tabs: const [
            Tab(
              text: 'WOMEN',
            ),
            Tab(
              text: 'KIDS',
            ),
            Tab(
              text: 'CURVE+PLUS',
            ),
            Tab(
              text: 'MEN',
            ),
            Tab(
              text: 'BEAUTY',
            ),
            Tab(
              text: 'HOME+PETS',
            ),
          ],
        ),
      ),
      AppBar(
        title: Text(
          'OSAMA SHOP NEW',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: InkWell(
            child: const Icon(
              Icons.email_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const MessageScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
        ),
        leadingWidth: 50.0,
        actions: [
          const SizedBox(
            width: 16.0,
          ),
          InkWell(
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const ShoppingBagScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
          const SizedBox(
            width: 16.0,
          ),
        ],
      ),
      AppBar(
        title: Text(
          'OSAMA SHOP',
          style: Theme.of(context).textTheme.headline3,
        ),
        centerTitle: true,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: InkWell(
            child: const Icon(
              Icons.email_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const MessageScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
        ),
        leadingWidth: 50.0,
        actions: [
          const SizedBox(
            width: 16.0,
          ),
          InkWell(
            child: const Icon(
              Icons.list_alt,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const AuthScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
          const SizedBox(
            width: 12.0,
          ),
          InkWell(
            child: const Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
              size: 28,
            ),
            onTap: () {
              Navigator.of(context).push(PageTransition(
                  child: const ShoppingBagScreen(),
                  type: PageTransitionType.rightToLeft));
            },
          ),
          const SizedBox(
            width: 16.0,
          ),
        ],
      ),
      null,
    ];

    bodyWidgets = [
      const TabBarView(
        children: [
          WomenScreen(),
          KidsScreen(),
          CurvePlusScreen(),
          MenScreen(),
          BeautyScreen(),
          HomePetsScreen(),
        ],
      ),
      const TabBarView(
        children: [
          WomenScreen(),
          KidsScreen(),
          CurvePlusScreen(),
          MenScreen(),
          BeautyScreen(),
          HomePetsScreen(),
        ],
      ),
      const TabBarView(
        children: [
          WomenScreen(),
          KidsScreen(),
          CurvePlusScreen(),
          MenScreen(),
          BeautyScreen(),
          HomePetsScreen(),
        ],
      ),
      const TabBarView(
        children: [
          WomenScreen(),
          KidsScreen(),
          CurvePlusScreen(),
          MenScreen(),
          BeautyScreen(),
          HomePetsScreen(),
        ],
      ),
      SafeArea(
        child: CustomRefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 2)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.list_alt,
                          color: Colors.black,
                          size: 28,
                        ),
                        onTap: () {
                          context.read<Auth>().logOut();
                          // Navigator.of(context).push(PageTransition(
                          //     child: const AuthScreen(),
                          //     type: PageTransitionType.rightToLeft));
                        },
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.qr_code_2_outlined,
                          color: Colors.black,
                          size: 28,
                        ),
                        onTap: () {},
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 28,
                        ),
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              child: const SettingsScreen(),
                              type: PageTransitionType.rightToLeft));
                        },
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.black,
                          size: 28,
                        ),
                        onTap: () {
                          Navigator.of(context).push(PageTransition(
                              child: const ShoppingBagScreen(),
                              type: PageTransitionType.rightToLeft));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32.0,
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        if(context.read<Auth>().user == null){
                          PushScreens.pushScreens(context, const AuthScreen());
                        }else{
                          PushScreens.pushScreens(context, const Profile());
                        }

                      },
                      child: Text(
                        context.watch<Auth>().user == null? 'SIGN IN / REGISTER >': context.watch<Auth>().user!.email != null?'Hi, ${context.watch<Auth>().user!.email!.split('@')[0]}':'Hi, ${context.watch<Auth>().user!.phoneNumber}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 32.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyText1!,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.label_important_outline_rounded,
                                size: 32,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text('Coupons'),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.paid_outlined,
                                size: 32,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text('Points'),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 32,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text('Wallet'),
                            ],
                          ),
                        ),
                        InkWell(
                          child: Column(
                            children: const [
                              Icon(
                                Icons.card_giftcard_outlined,
                                size: 32,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text('Gift Card'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  thickness: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Orders',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            'View All >',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyText1!,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.credit_card_outlined,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Unpaid'),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.storage_sharp,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Processing'),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.art_track,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Shipped'),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.backpack_sharp,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Returns'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'More Services',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: DefaultTextStyle(
                          style: Theme.of(context).textTheme.bodyText1!,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.support_agent_outlined,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Support'),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.playlist_add_check,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Survey Center'),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.lock_open_outlined,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Free Trail Center'),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.ios_share,
                                      size: 32,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Text('Share&Earn'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 10.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          onTap: (int index) {
                            _tabController.animateTo(index);
                          },
                          controller: _tabController,
                          labelColor: Colors.black,
                          labelStyle: Theme.of(context).textTheme.headline2,
                          unselectedLabelColor: Colors.grey[600],
                          indicatorColor: Colors.black,
                          indicatorWeight: 2,
                          indicatorPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          isScrollable: true,
                          tabs: const [
                            Tab(
                              text: 'Wishlist',
                            ),
                            Tab(
                              text: 'Recently Viewed',
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 150,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.favorite_border_sharp,
                                    size: 64.0,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontSize: 18.0),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context).push(PageTransition(
                                                child: const AuthScreen(),
                                                type: PageTransitionType.rightToLeft));
                                          },
                                        children: [
                                          TextSpan(
                                            text: ' to view your Wishlist',
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 18.0),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'You have not viewed anything.',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  OutlinedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          const RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2.0))),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _selectedIndex = 0;
                                      });
                                    },
                                    child: const Text(
                                      'Go shopping',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          builder: (BuildContext context, Widget child,
              IndicatorController controller) {
            return AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, _) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    if (!controller.isIdle)
                      Positioned(
                        top: 35.0 * controller.value,
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            value: !controller.isLoading
                                ? controller.value.clamp(0.0, 1.0)
                                : null,
                          ),
                        ),
                      ),
                    if (!controller.isIdle)
                      Positioned(
                        top: 35.0 * controller.value,
                        child: const SizedBox(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(0, 100.0 * controller.value),
                      child: child,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    ];
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _categorySearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: appBarWidgets[_selectedIndex],
        body: bodyWidgets[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          iconSize: 32,
          selectedFontSize: 16.0,
          unselectedFontSize: 16.0,
          unselectedItemColor: Colors.grey[600],
          selectedItemColor: Colors.black,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Shop',
              icon: Icon(Icons.home_filled),
            ),
            BottomNavigationBarItem(
              label: 'Category',
              icon: Icon(Icons.manage_search),
            ),
            BottomNavigationBarItem(
              label: 'New',
              icon: Icon(Icons.new_releases_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Gals',
              icon: Icon(Icons.local_fire_department_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Me',
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {}
}
