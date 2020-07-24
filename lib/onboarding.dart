import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ui
import 'package:NOVID_19/theme/colors/dark_colors.dart';
// novid
import 'package:NOVID_19/helper/localization.dart';

import 'package:NOVID_19/novid19.dart';

class OnBoardingScreen extends StatefulWidget {
    static String tag = 'onboarding-screen';

    @override
    _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
    final introKey = GlobalKey<IntroductionScreenState>();

    void _onIntroEnd(context) async {
        await SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('onboarded', true);
        });

        Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => Novid19Screen())
        );
    }

    Widget _buildImage(String assetName) {
        return Align(
            child: Image.asset('assets/onboarding/$assetName.png', width: 350.0),
            alignment: Alignment.bottomCenter,
        );
    }

    @override
    Widget build(BuildContext context) {
        const bodyStyle = TextStyle(
            color: Colors.white,
            fontSize: 19.0
        );
        const pageDecoration = const PageDecoration(
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.w700
            ),
            bodyTextStyle: bodyStyle,
            descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            pageColor: DarkColors.primary,
            imagePadding: EdgeInsets.zero,
        );

        return WillPopScope(
            child: IntroductionScreen(
                key: introKey,
                pages: [
                    PageViewModel(
                        title: "Deine Hilfe ist gefragt!",
                        body: "Damit das aktuell kursierende Coronavirus so schnell wie möglich besiegt werden kann sind wir alle dazu angehalten genügend Abstand zu anderen Menschen zu halten. NOVID-19 möchte dich dabei unterstützen.",
                        image: _buildImage('fighting-coronavirus'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Deine täglichen Kontakte",
                        body: "Für einen besseren Überblick, trackt die App alle Kontakte mit Personen die die Corona-App verwenden und zeigt sie dir an.\n\nDamit deine Kontakte getracked werden können, lass die App bitte im Hintergrund laufen und beende sie nicht.",
                        image: _buildImage('daily_contacts'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Erkenne lange Kontakte",
                        body: "Um dich selbst besser schützen zu können, solltest du längere Kontakte vermeiden. NOVID-19 hilft dir dabei die Länge der Kontakte in deiner Nähe zu erkennen.",
                        image: _buildImage('nearest_contacts'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Das braucht die App",
                        body: "Um Kontakte verfolgen zu können muss NOVID-19 auf deine Standortdaten zugreifen, sie sind nötig um über Bluetooth nach anderen Geräten zu suchen, die App wird dabei niemals auf dein GPS zugreifen!",
                        image: _buildImage('data'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Updates",
                        body: "In den kommenden Wochen wird es einige Updates geben, ein großes Feature wird dabei eine Kalenderansicht der Kontakte sein.",
                        image: _buildImage('stay-positive'),
                        decoration: pageDecoration,
                    ),
                ],
                onDone: () => _onIntroEnd(context),
                //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
                showSkipButton: false,
                skipFlex: 0,
                nextFlex: 0,
                skip: const Text('Skip', style: TextStyle(color: Colors.white)),
                next: const Icon(Icons.arrow_forward, color: Colors.white,),
                done: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                dotsDecorator: const DotsDecorator(
                    size: Size(10.0, 10.0),
                    color: DarkColors.brand,
                    activeColor: DarkColors.brand,
                    activeSize: Size(22.0, 10.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                ),
            ),
            onWillPop: () async => false,
        );
    }
}
