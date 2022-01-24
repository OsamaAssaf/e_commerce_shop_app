import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import './secondary_screens/auth_screen.dart';
import './secondary_screens/first_time.dart';
import './secondary_screens/message_screen.dart';
import './secondary_screens/shopping_bag_screen.dart';
import './secondary_screens/terms_and_conditions_screen.dart';
import './secondary_screens/wishlist_screen.dart';
import 'controllers/settings.dart';
import 'main_screens/Home.dart';
import 'main_screens/settings_screen.dart';
import 'controllers/auth.dart';

late bool isFirstTime;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SharedPreferences _prefs = await SharedPreferences.getInstance();
  isFirstTime = _prefs.getBool('isFirstTime') ?? true;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth()),
      ChangeNotifierProvider(create: (_) => Settings()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        context.read<Auth>().changeUserState(user);
        print('User is currently signed out!');
      } else {
        context.read<Auth>().changeUserState(user);
        print('User is signed in!');
        print(user.emailVerified);
      }
    });
    context.read<Settings>().initLocale();
    super.initState();
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.watch<Settings>().locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(primary: Colors.white),
        canvasColor: Colors.white,
        textTheme: TextTheme(
          headline1: GoogleFonts.notoSans(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          headline2: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.black
          ),
          headline3:  TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16.0,
              color: Colors.grey[700]
          ),
          headline4: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18.0,
              color: Colors.black
          ),
          subtitle1: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.black
          ),
          // headline3: GoogleFonts.notoSans(
          //   textStyle: const TextStyle(
          //     color: Colors.black,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 22,
          //   ),
          // ),
          // headline4: const TextStyle(
          //   fontWeight: FontWeight.normal,
          //   fontSize: 20.0,
          //   color: Colors.black,
          // ),
          // subtitle1: const TextStyle(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 22.0,
          //   color: Colors.black,
          // ),
          // subtitle2: const TextStyle(
          //   fontWeight: FontWeight.normal,
          //   fontSize: 18.0,
          //   color: Colors.grey,
          // ),
          // bodyText1: TextStyle(
          //   fontWeight: FontWeight.normal,
          //   fontSize: 16.0,
          //   color: Colors.grey[700],
          // ),
          // bodyText2: const TextStyle(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 18.0,
          //   color: Colors.black,
          // ),
        ),
      ),
      home:isFirstTime ?const FirstTime() :const Home(),
      routes: {
        Home.pageRoute: (_) => const Home(),
        FirstTime.pageRoute: (_) => const FirstTime(),
        AuthScreen.pageRoute: (_) => const AuthScreen(),
        MessageScreen.pageRoute: (_) => const MessageScreen(),
        WishlistScreen.pageRoute: (_) => const WishlistScreen(),
        ShoppingBagScreen.pageRoute: (_) => const ShoppingBagScreen(),
        TermsConditions.pageRoute: (_) => const TermsConditions(),
        SettingsScreen.pageRoute: (_) => const SettingsScreen(),
      },
    );
  }
}
