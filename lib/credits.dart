import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:CoTrack/helper/localization.dart';
import 'package:CoTrack/theme/colors/dark_colors.dart';
import 'package:CoTrack/widgets/credits_row.dart';

class CreditsScreen extends StatelessWidget {
    static String tag = 'credits-screen';

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'CoTrack',
            theme: ThemeData(
                primaryColor: DarkColors.secondary,
                scaffoldBackgroundColor: DarkColors.primary
            ),
            supportedLocales: [
                Locale('de')
            ],
            localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: Text(AppLocalizations.of(context).translate('CREDITS_TITLE')),
                ),
                body: Scaffold(
                    backgroundColor: DarkColors.primary,
                    body: SafeArea(
                        child: Column(
                            children: <Widget>[
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                            children: <Widget>[
                                                Container(
                                                    color: Colors.transparent,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 20.0, vertical: 10.0
                                                    ),
                                                    child: Column(
                                                        children: <Widget>[
                                                            SizedBox(
                                                                height: 25.0
                                                            ),
                                                            Align(
                                                                child: Image.asset('assets/credits/winners.png', width: 300.0),
                                                                alignment: Alignment.bottomCenter,
                                                            ),
                                                            SizedBox(
                                                                height: 25.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('CREDITS_PEOPLE_LABEL'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18.0,
                                                                                fontWeight: FontWeight.w400,
                                                                                letterSpacing: 1.1,
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                            SizedBox(
                                                                height: 35.0
                                                            ),
                                                            CreditsRow(
                                                                color: Colors.white,
                                                                text: 'Kristina Vogel',
                                                                instagram: 'birdkris',
                                                            ),
                                                            SizedBox(
                                                                height: 35.0
                                                            ),
                                                            CreditsRow(
                                                                color: Colors.white,
                                                                text: 'DelirusMedia',
                                                                twitter: 'delirusmedia',
                                                            ),
                                                            SizedBox(
                                                                height: 60.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('CREDITS_ASSETS_LABEL'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18.0,
                                                                                fontWeight: FontWeight.w400,
                                                                                letterSpacing: 1.1,
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                            SizedBox(
                                                                height: 35.0
                                                            ),
                                                            CreditsRow(
                                                                color: Colors.white,
                                                                text: 'Freepik',
                                                                url: 'https://freepik.com',
                                                            ),
                                                            SizedBox(
                                                                height: 35.0
                                                            ),
                                                            CreditsRow(
                                                                color: Colors.white,
                                                                text: 'Stories by Freepik',
                                                                url: 'https://stories.freepik.com',
                                                            ),
                                                        ],
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
                floatingActionButton: FloatingActionButton(
                    onPressed: () {
                        Navigator.pop(context);
                    },
                    child: Icon(Icons.undo),
                    backgroundColor: DarkColors.secondary,
                    elevation: 8,
                ),
            ),
        );
    }
}
