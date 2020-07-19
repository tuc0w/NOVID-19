// platform
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// novid
import 'package:NOVID_19/onboarding.dart';
import 'package:NOVID_19/novid19.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(Novid19App()));
}

class Novid19App extends StatefulWidget {
    @override
    _Novid19AppState createState() => _Novid19AppState();
}

class _Novid19AppState extends State<Novid19App> {
    static bool onboarded = false;

    final routes = <String, WidgetBuilder>{
        Novid19Screen.tag: (context) => Novid19Screen(),
        OnBoardingScreen.tag: (context) => OnBoardingScreen(),
    };

    @override
    void initState() {
        super.initState();
        initSharedPreferences();
    }

    Future<void> initSharedPreferences() async {
        await SharedPreferences.getInstance().then((prefs) {
            onboarded = prefs.getBool('onboarded') ?? false;
        });
    }

    @override
    Widget build(BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
        );

        return MaterialApp(
            title: 'NOVID-19',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.light,
                primarySwatch: Colors.blue,
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                ),
            ),
            home: Builder(builder: (context) {
                if (!onboarded) {
                    return OnBoardingScreen();
                } else {
                    return Novid19Screen();
                }
            }),
            routes: routes,
        );
    }
}
