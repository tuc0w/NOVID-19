// platform
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// novid
import 'package:CoTrack/onboarding.dart';
import 'package:CoTrack/cotrack.dart';

bool onboarded = false;

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPreferences.getInstance().then((prefs) {
        onboarded = prefs.getBool('onboarded') ?? false;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(Novid19App()));
}

class Novid19App extends StatefulWidget {
    @override
    _Novid19AppState createState() => _Novid19AppState();
}

class _Novid19AppState extends State<Novid19App> {
    final routes = <String, WidgetBuilder>{
        Novid19Screen.tag: (context) => Novid19Screen(),
        OnBoardingScreen.tag: (context) => OnBoardingScreen(),
    };

    @override
    void initState() {
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
        );

        return MaterialApp(
            title: 'CoTrack',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                brightness: Brightness.dark,
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
