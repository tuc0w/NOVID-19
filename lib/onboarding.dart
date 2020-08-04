import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ui
import 'package:CoTrack/theme/colors/dark_colors.dart';

// CoTrack
import 'package:CoTrack/cotrack.dart';

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
            MaterialPageRoute(builder: (_) => CoTrackScreen())
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
            fontSize: 18.0,
            height: 1.3
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
                        body: "Damit sich Viren nicht so schnell ausbreiten können sind wir alle dazu angehalten genügend Abstand zu anderen Menschen zu halten. CoTrack möchte dich dabei unterstützen.",
                        image: _buildImage('fighting-coronavirus'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Deine täglichen Kontakte",
                        body: "CoTrack trackt anonymisiert alle Kontakte mit Personen, die eine Warn-App verwenden.\n\nStarte die App wenn du unterwegs bist. So kannst du z.B. beim Einkaufen, auf der Arbeit oder an anderen Orten besser nachvollziehen, ob du kritische Kontaktpunkte hast.",
                        image: _buildImage('daily_contacts'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Erkenne lange Kontakte",
                        body: "Um dich selbst besser schützen zu können, solltest du längere Kontakte vermeiden:\n\nCoTrack trackt Kontakte innerhalb von 2 Metern. Anhaltende Kontakte werden nach 5 Minuten orange und ab 10 Minuten rot dargestellt.",
                        image: _buildImage('nearest_contacts'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Das braucht die App",
                        body: "Um Kontakte verfolgen zu können, muss CoTrack auf deine Standortdaten zugreifen. Diese sind nötig um über Bluetooth nach anderen Geräten zu suchen.\n\nDie App wird dabei niemals auf dein GPS zugreifen!",
                        image: _buildImage('data'),
                        decoration: pageDecoration,
                    ),
                    PageViewModel(
                        title: "Los geht's!",
                        bodyWidget: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                                Text(
                                    "App an!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                        height: 1.3
                                    ),
                                ),
                                Text(
                                    "Abstand halten!",
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                        height: 1.3
                                    ),
                                ),
                                Text("Gesund bleiben!\n",
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                        height: 1.3
                                    ),
                                ),
                                FaIcon(FontAwesomeIcons.smile),
                            ],
                        ),
                        image: _buildImage('stay-positive'),
                        decoration: pageDecoration,
                    ),
                ],
                onDone: () => _onIntroEnd(context),
                showSkipButton: false,
                skipFlex: 0,
                nextFlex: 0,
                skip: const Text('Skip', style: TextStyle(color: Colors.white)),
                next: const Icon(Icons.arrow_forward, color: Colors.white,),
                done: const Text('Fertig', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
