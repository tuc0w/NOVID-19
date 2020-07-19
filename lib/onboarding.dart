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
            prefs.setBool('onboarded', false);
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
                        title: "Danke!",
                        body:
                            "Für deine Hilfe im Kampf gegen COVID-19.",
                        image: _buildImage('fighting-coronavirus'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Halte Abstand!",
                        body:
                            "Mit NOVID-19 kannst du deine Kontakte verfolgen und immer einsehen wie viele längere Kontakte du hattest. Bitte denke daran dass die Entfernungen nur geschätzt werden können",
                        image: _buildImage('social-distancing'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Wasche deine Hände!",
                        body:
                            "Bitte denke an die Hygieneregeln und wasche regelmäßig deine Hände.",
                        image: _buildImage('handwashing'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Was passiert mit deinen Daten?",
                        body:
                            "Deine Daten verlassen zu keinem Zeitpunkt dein Smartphone, die App kommuniziert nicht mit dem Internet und versendet keine Daten.",
                        image: _buildImage('data'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Bleib positiv!",
                        body:
                            "",
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
