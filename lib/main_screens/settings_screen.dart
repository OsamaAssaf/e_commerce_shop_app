import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:osama_shop/account_screens/edit_profile.dart';
import 'package:osama_shop/controllers/auth.dart';
import 'package:osama_shop/controllers/settings.dart';
import 'package:osama_shop/controllers/push_screens.dart';
import 'package:osama_shop/secondary_screens/account_screen.dart';
import 'package:osama_shop/secondary_screens/auth_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String pageRoute = '/settings_screen';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? language;

  late ItemScrollController? _scrollController;
  late TextEditingController _countryController;
  late TextEditingController _currencyController;

  List<String> countriesName = [];
  List<String> alphabets = [];
  Map<String, int> alphabetsIndex = {};

  List<String> currencyList = [];

  String? currentCountry;
  String? currentCurrencyName;

  String countrySearch = '';
  List<String> countrySearchList = [];

  getCountries() async {
    await CountryCodes.init();
    final CountryDetails details = CountryCodes.detailsForLocale();
    currentCountry = details.name!;
    List<Country>? countries;
    try {
      countries = await IsoCountries.isoCountries;
    } on PlatformException {
      countries = null;
    }
    countriesName = countries!.map((e) => e.name).toList();

    for (String item in countriesName) {
      if (!alphabets.contains(item[0].toUpperCase())) {
        alphabets.add(item[0]);
      }
    }

    for (int i = 0; i < alphabets.length; i++) {
      if (!alphabetsIndex.containsKey(alphabets[i])) {
        String c = countriesName.firstWhere((element) => element[0] == alphabets[i]);
        alphabetsIndex[alphabets[i]] = countriesName.indexWhere((element) => element == c);
      }
    }
  }

  @override
  void initState() {
    getCountries();
    currencyList = context.read<Settings>().currencyList;
    _scrollController = ItemScrollController();
    _countryController = TextEditingController();
    _currencyController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = '';
    User? user = context.read<Auth>().user;
    if (user != null) {
      if (context.read<Auth>().user!.email != null) {
        name = context.watch<Auth>().user!.email!.split('@')[0];
      } else {
        name = context.watch<Auth>().user!.phoneNumber!;
      }
    }

    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    language = context.watch<Settings>().language;
    currentCountry = context.watch<Settings>().country;
    currentCurrencyName = context.watch<Settings>().currency;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline3,
        ),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(
              thickness: 10.0,
            ),
            if (context.watch<Auth>().user == null)
              boldListTile(context, 'SIGN IN / REGISTER', () {
                Navigator.of(context).push(PageTransition(
                    child: const AuthScreen(), type: PageTransitionType.rightToLeft));
              }),
            if (user != null)
              boldListTile(
                  context, name, () => PushScreens.pushScreens(context, const EditProfileScreen())),
            const Divider(
              thickness: 10.0,
            ),
            normalListTile(context, 'Address Book', () {
              Navigator.of(context).push(
                  PageTransition(child: const AuthScreen(), type: PageTransitionType.rightToLeft));
            }),
            const Divider(),
            normalListTile(context, 'My Payment Options', () {
              Navigator.of(context).push(
                  PageTransition(child: const AuthScreen(), type: PageTransitionType.rightToLeft));
            }),
            if (context.watch<Auth>().user != null) const Divider(),
            if (context.watch<Auth>().user != null)
              normalListTile(context, 'Account security', () {
                PushScreens.pushScreens(context, const AccountScreen());
              }),
            const Divider(
              thickness: 10.0,
            ),
            normalListTile(context, 'Country/Region', () {
              countryBottomSheet(context, height, width);
            }, Text(currentCountry!)),
            const Divider(),
            normalListTile(context, appLocalizations!.language, () {
              languageBottomSheet(context, height);
            }, Text(language!)),
            const Divider(),
            normalListTile(context, 'Currency', () {
              currencyBottomSheet(context, height);
            }, Text(currentCurrencyName!)),
            const Divider(),
            normalListTile(context, 'Content Preferences', () {}),
            const Divider(),
            normalListTile(context, 'Clear Cache', () {}),
            const Divider(
              thickness: 10.0,
            ),
            normalListTile(context, 'Rating & Feedback', () {}),
            const Divider(),
            normalListTile(context, 'Connect to Us', () {}),
            const Divider(),
            normalListTile(context, 'About Osama Shop', () {}),
            const Divider(),
            Container(
              width: double.infinity,
              height: 75,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  'Version 0.0.1',
                  style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.normal),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile boldListTile(BuildContext context, String title, Function() onTap) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline2,
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 18.0,
      ),
      onTap: onTap,
    );
  }

  ListTile normalListTile(BuildContext context, String title, Function() onTap, [Widget? widget]) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline4,
      ),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget != null) widget,
            const Icon(
              Icons.arrow_forward_ios,
              size: 18.0,
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Future<dynamic> countryBottomSheet(BuildContext context, double height, double width) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: height * 0.75,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(AppLocalizations.of(context)!.region),
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _countryController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        hintText: AppLocalizations.of(context)!.region,
                        border: const OutlineInputBorder(borderSide: BorderSide.none)),
                    onChanged: (value) {},
                  ),
                ),
                countrySearch == ''
                    ? Expanded(
                        child: Stack(
                          children: [
                            Directionality(
                              textDirection: ui.TextDirection.ltr,
                              child: SizedBox(
                                width: width,
                                height: height,
                                child: ScrollablePositionedList.builder(
                                  itemScrollController: _scrollController,
                                  itemCount: countriesName.length,
                                  itemBuilder: (ctx, index) {
                                    String country = countriesName[index];
                                    if (index == alphabetsIndex[country[0]]) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              alphabetsIndex.keys
                                                  .firstWhere((element) => element == country[0]),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          ListTile(
                                              title: Text(country),
                                              onTap: () {
                                                setState(() {
                                                  currentCountry = country;
                                                });
                                                Navigator.of(context).pop();
                                              }),
                                        ],
                                      );
                                    }
                                    return ListTile(
                                      title: Text(country),
                                      onTap: () {
                                        setState(() {
                                          currentCountry = country;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              child: SizedBox(
                                width: width * 0.05,
                                height: height,
                                child: ListView.builder(
                                  itemCount: alphabets.length,
                                  itemBuilder: (ctx, index) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          child: Text(alphabets[index]),
                                          onTap: () {
                                            print('onTap: ${alphabetsIndex[alphabets[index]]}');
                                            _scrollController!.scrollTo(
                                                index: alphabetsIndex[alphabets[index]]!,
                                                duration: const Duration(milliseconds: 200));
                                          },
                                          onVerticalDragStart: (DragStartDetails details) {
                                            print('Start: $details');
                                            print('Start: ${alphabetsIndex[alphabets[index]]}');
                                            _scrollController!.scrollTo(
                                                index: alphabetsIndex[alphabets[index]]!,
                                                duration: const Duration(milliseconds: 200));
                                          },
                                          onVerticalDragUpdate: (DragUpdateDetails details) {
                                            print('Update: $details');
                                            print('Update: ${alphabetsIndex[alphabets[index]]}');
                                            _scrollController!.scrollTo(
                                                index: alphabetsIndex[alphabets[index]]!,
                                                duration: const Duration(milliseconds: 200));
                                          },
                                          onVerticalDragEnd: (DragEndDetails details) {
                                            print('End: $details');
                                            print('End: ${alphabetsIndex[alphabets[index]]}');
                                            _scrollController!.scrollTo(
                                                index: alphabetsIndex[alphabets[index]]!,
                                                duration: const Duration(milliseconds: 200));
                                          },
                                        ),
                                        const SizedBox(
                                          height: 2.0,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: countrySearchList.length,
                            itemBuilder: (ctx, index) {
                              return ListTile(
                                title: Text(countrySearchList[index]),
                              );
                            }),
                      ),
                Expanded(
                  child: Stack(
                    children: [
                      Directionality(
                        textDirection: ui.TextDirection.ltr,
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: ScrollablePositionedList.builder(
                            itemScrollController: _scrollController,
                            itemCount: countriesName.length,
                            itemBuilder: (ctx, index) {
                              String country = countriesName[index];
                              if (index == alphabetsIndex[country[0]]) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0),
                                      child: Text(
                                        alphabetsIndex.keys
                                            .firstWhere((element) => element == country[0]),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    ListTile(
                                        title: Text(country),
                                        onTap: () {
                                          setState(() {
                                            currentCountry = country;
                                          });
                                          Navigator.of(context).pop();
                                        }),
                                  ],
                                );
                              }
                              return ListTile(
                                title: Text(country),
                                onTap: () {
                                  setState(() {
                                    currentCountry = country;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        child: SizedBox(
                          width: width * 0.05,
                          height: height,
                          child: ListView.builder(
                            itemCount: alphabets.length,
                            itemBuilder: (ctx, index) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Text(alphabets[index]),
                                    onTap: () {
                                      print('onTap: ${alphabetsIndex[alphabets[index]]}');
                                      _scrollController!.scrollTo(
                                          index: alphabetsIndex[alphabets[index]]!,
                                          duration: const Duration(milliseconds: 200));
                                    },
                                    onVerticalDragStart: (DragStartDetails details) {
                                      print('Start: $details');
                                      print('Start: ${alphabetsIndex[alphabets[index]]}');
                                      _scrollController!.scrollTo(
                                          index: alphabetsIndex[alphabets[index]]!,
                                          duration: const Duration(milliseconds: 200));
                                    },
                                    onVerticalDragUpdate: (DragUpdateDetails details) {
                                      print('Update: $details');
                                      print('Update: ${alphabetsIndex[alphabets[index]]}');
                                      _scrollController!.scrollTo(
                                          index: alphabetsIndex[alphabets[index]]!,
                                          duration: const Duration(milliseconds: 200));
                                    },
                                    onVerticalDragEnd: (DragEndDetails details) {
                                      print('End: $details');
                                      print('End: ${alphabetsIndex[alphabets[index]]}');
                                      _scrollController!.scrollTo(
                                          index: alphabetsIndex[alphabets[index]]!,
                                          duration: const Duration(milliseconds: 200));
                                    },
                                  ),
                                  const SizedBox(
                                    height: 2.0,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<dynamic> languageBottomSheet(BuildContext context, double height) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return SizedBox(
          height: height * 0.25,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Text(AppLocalizations.of(context)!.language),
              const SizedBox(
                height: 10.0,
              ),
              const Divider(),
              ListTile(
                title: const Text('العربية'),
                onTap: () {
                  context.read<Settings>().setLocale(const Locale('ar'));
                  setState(() {
                    language = 'العربية';
                  });
                  Navigator.of(context).pop();
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  context.read<Settings>().setLocale(const Locale('en'));
                  setState(() {
                    language = 'English';
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> currencyBottomSheet(BuildContext context, double height) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: height * 0.75,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Text(AppLocalizations.of(context)!.currency),
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _currencyController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        hintText: AppLocalizations.of(context)!.currency,
                        border: const OutlineInputBorder(borderSide: BorderSide.none)),
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: Directionality(
                    textDirection: ui.TextDirection.ltr,
                    child: ListView.builder(
                      itemCount: currencyList.length,
                      itemBuilder: (ctx, index) {
                        String currency = currencyList[index];
                        NumberFormat format = NumberFormat.simpleCurrency(name: currency);
                        return Column(
                          children: [
                            const Divider(),
                            ListTile(
                              leading: Text(currency),
                              title: Text(format.currencySymbol),
                              trailing: currentCurrencyName == currency
                                  ? const Icon(Icons.done)
                                  : Container(
                                      width: 0.0,
                                    ),
                              onTap: () {
                                context.read<Settings>().setCurrency(currency);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
