import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iso_countries/iso_countries.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:country_codes/country_codes.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_screens/Home.dart';

class FirstTime extends StatefulWidget {
  const FirstTime({Key? key}) : super(key: key);

  static const String pageRoute = '/first_time';

  @override
  _FirstTimeState createState() => _FirstTimeState();
}

class _FirstTimeState extends State<FirstTime> {
  late ItemScrollController? _scrollController;
  late TextEditingController _countryController;
  late TextEditingController _currencyController;

  List<String> countriesName = [];
  List<String> alphabets = [];
  Map<String, int> alphabetsIndex = {};

  String currentCountry = 'United States';
  String currentCountryCode = '';
  String currentCurrencyName = 'USD';

  String countrySearch = '';
  List<String> countrySearchList = [];

  List<String> currencyList = [
    'USD',
    'SAR',
    'KWD',
    'QAR',
    'OMR',
    'BHD',
    'AED',
    'EUR',
    'AUD',
    'GBP',
    'SEK',
    'MAD',
    'JOD'
  ];

  String language = 'English';

  getCountries() async {
    await CountryCodes.init();
    final CountryDetails details = CountryCodes.detailsForLocale();
    currentCountry = details.name!;

    List<Country>? countries;
    try {
      countries = await IsoCountries.iso_countries;
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
        String c =
            countriesName.firstWhere((element) => element[0] == alphabets[i]);
        alphabetsIndex[alphabets[i]] =
            countriesName.indexWhere((element) => element == c);
      }
    }
  }

  void currency() {
    Locale locale = Localizations.localeOf(context);
    NumberFormat format =
        NumberFormat.simpleCurrency(locale: locale.toString());
    currentCurrencyName = format.currencyName!;
  }

  @override
  void initState() {
    getCountries();
    _scrollController = ItemScrollController();
    _countryController = TextEditingController();
    _currencyController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    currency();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController = null;
    _countryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/first-time.png',
                  width: width,
                  fit: BoxFit.fill,
                  height: height * 0.25,
                ),
                const Positioned.fill(
                  child: Align(
                    child: Text('Welcome to Osama shop'),
                    alignment: Alignment.bottomCenter,
                  ),
                  bottom: 10.0,
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            buildListTile(context, height, width,'Country/Region',currentCountry,(){
              countryBottomSheet(context, height, width);
            }),
            // buildListTile(context, height, width),
            const Divider(),
            buildListTile(context, height, width,'Language',language,(){
              languageBottomSheet(context, height);
            }),
            // buildListTile2(context, height),
            const Divider(),
            buildListTile(context, height, width,'Currency',currentCurrencyName,(){
              currencyBottomSheet(context, height);
            }),
            // buildListTile3(context, height),
            const Divider(),
            goShoppingButton(),
            const Text(
              'You can go to the "Settings" page to modify later',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Padding goShoppingButton() {
    return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text(
                  'GO SHOPPING',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero))),
                onPressed: () async{
                  SharedPreferences _prefs = await SharedPreferences.getInstance();
                  _prefs.setBool('isFirstTime', false);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const Home()));

                },
              ),
            ),
          );
  }

  ListTile buildListTile(BuildContext context, double height, double width,String title,String subTitle,Function() onTap){
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
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
                          child: GestureDetector(
                            child: const Icon(Icons.close),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          alignment: Alignment.topRight,
                        ),
                        const Text('Currency'),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextField(
                            controller: _currencyController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Currency',
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            onChanged: (value) {},
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: currencyList.length,
                            itemBuilder: (ctx, index) {
                              String currency = currencyList[index];
                              NumberFormat format =
                              NumberFormat.simpleCurrency(name: currency);

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
                                      setState(() {
                                        currentCurrencyName = currency;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
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
                  height: height * 0.35,
                  child: Column(
                    children: [
                      Align(
                        child: GestureDetector(
                          child: const Icon(Icons.close),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        alignment: Alignment.topRight,
                      ),
                      const Text('Language'),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text('العربية'),
                        onTap: () {
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
                          setState(() {
                            language = 'English';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.only(left: 32.0, right: 32.0, top: 10.0),
                        child: Text(
                          'Because the language has been modified, you need to restart to enter the app',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                );
              },
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
                          child: GestureDetector(
                            child: const Icon(Icons.close),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          alignment: Alignment.topRight,
                        ),
                        const Text('Country/Region'),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: TextField(
                            controller: _countryController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey[200],
                                filled: true,
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Country/Region',
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            onChanged: (value) {},
                          ),
                        ),
                        countrySearch == ''
                            ? Expanded(
                          child: Stack(
                            children: [
                              SizedBox(
                                width: width,
                                height: height,
                                child: ScrollablePositionedList.builder(
                                  itemScrollController: _scrollController,
                                  itemCount: countriesName.length,
                                  itemBuilder: (ctx, index) {
                                    String country = countriesName[index];
                                    if (index == alphabetsIndex[country[0]]) {
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 16.0),
                                            child: Text(
                                              alphabetsIndex.keys.firstWhere(
                                                      (element) =>
                                                  element == country[0]),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
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
                              Positioned(
                                right: 5,
                                child: SizedBox(
                                  width: width * 0.05,
                                  height: height,
                                  child: ListView.builder(
                                    itemCount: alphabets.length,
                                    itemBuilder: (ctx, index) {
                                      return Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            child: Text(alphabets[index]),
                                            onTap: () {
                                              print(
                                                  'onTap: ${alphabetsIndex[alphabets[index]]}');
                                              _scrollController!.scrollTo(
                                                  index: alphabetsIndex[
                                                  alphabets[index]]!,
                                                  duration: const Duration(
                                                      milliseconds: 200));
                                            },
                                            onVerticalDragStart:
                                                (DragStartDetails details) {
                                              print('Start: $details');
                                              print(
                                                  'Start: ${alphabetsIndex[alphabets[index]]}');
                                              _scrollController!.scrollTo(
                                                  index: alphabetsIndex[
                                                  alphabets[index]]!,
                                                  duration: const Duration(
                                                      milliseconds: 200));
                                            },
                                            onVerticalDragUpdate:
                                                (DragUpdateDetails details) {
                                              print('Update: $details');
                                              print(
                                                  'Update: ${alphabetsIndex[alphabets[index]]}');
                                              _scrollController!.scrollTo(
                                                  index: alphabetsIndex[
                                                  alphabets[index]]!,
                                                  duration: const Duration(
                                                      milliseconds: 200));
                                            },
                                            onVerticalDragEnd:
                                                (DragEndDetails details) {
                                              print('End: $details');
                                              print(
                                                  'End: ${alphabetsIndex[alphabets[index]]}');
                                              _scrollController!.scrollTo(
                                                  index: alphabetsIndex[
                                                  alphabets[index]]!,
                                                  duration: const Duration(
                                                      milliseconds: 200));
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
                      ],
                    ),
                  );
                });
  }




}
