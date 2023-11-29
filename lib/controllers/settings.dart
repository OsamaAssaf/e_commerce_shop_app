import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings with ChangeNotifier {
  /// Language
  Locale? locale = const Locale('en');
  String? language = 'English';

  final isoLanguages = {
    "ar": {"name": "Arabic", "nativeName": "العربية"},
    "en": {"name": "English", "nativeName": "English"},
  };

  initLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringLocale = prefs.getString('locale') ?? const Locale('en').toString();
    locale = Locale.fromSubtags(languageCode: stringLocale);
    language = isoLanguages[locale!.languageCode]!['nativeName'];
  }

  void setLocale(Locale value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('locale', value.toString());
    locale = value;
    language = isoLanguages[value.languageCode]!['nativeName'];
    notifyListeners();
  }

  /// Country & Currency
  String country = 'United States';
  String currency = 'USD';

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

  void setCountry(String value) {
    country = value;
    notifyListeners();
  }

  void setCurrency(String value) {
    currency = value;
    notifyListeners();
  }
}
