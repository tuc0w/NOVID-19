// platform
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// CoTrack
import 'package:CoTrack/onboarding.dart';
import 'package:CoTrack/cotrack.dart';

bool onboarded = false;

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPreferences.getInstance().then((prefs) {
        onboarded = prefs.getBool('onboarded') ?? false;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(CoTrackApp()));
}

class CoTrackApp extends StatefulWidget {
    @override
    _CoTrackAppState createState() => _CoTrackAppState();
}

class _CoTrackAppState extends State<CoTrackApp> {
    final routes = <String, WidgetBuilder>{
        CoTrackScreen.tag: (context) => CoTrackScreen(),
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
                    return CoTrackScreen();
                }
            }),
            routes: routes,
        );
    }
}
