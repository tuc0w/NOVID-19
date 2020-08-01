import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:NOVID_19/helper/localization.dart';
import 'package:NOVID_19/theme/colors/dark_colors.dart';
import 'package:NOVID_19/widgets/subheading.dart';

class PrivacyScreen extends StatelessWidget {
    static String tag = 'privacy-screen';

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
                    title: Text(AppLocalizations.of(context).translate('PRIVACY_TITLE')),
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
                                                                child: Image.asset('assets/privacy/security.png', width: 200.0),
                                                                alignment: Alignment.bottomCenter,
                                                            ),
                                                            SizedBox(
                                                                height: 15.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('PRIVACY_HEADING_ROW_1'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18.0,
                                                                                fontWeight: FontWeight.w700,
                                                                                letterSpacing: 1.1,
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                            SizedBox(
                                                                height: 15.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('PRIVACY_TEXT_ROW_1'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight.w400
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),

                                                            SizedBox(
                                                                height: 69.0
                                                            ),
                                                            Align(
                                                                child: Image.asset('assets/privacy/finance.png', width: 200.0),
                                                                alignment: Alignment.bottomCenter,
                                                            ),
                                                            SizedBox(
                                                                height: 15.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('PRIVACY_HEADING_ROW_2'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18.0,
                                                                                fontWeight: FontWeight.w700,
                                                                                letterSpacing: 1.1,
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                            SizedBox(
                                                                height: 15.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('PRIVACY_TEXT_ROW_2'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight.w400
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),

                                                            SizedBox(
                                                                height: 69.0
                                                            ),
                                                            Align(
                                                                child: Image.asset('assets/privacy/data.png', width: 300.0),
                                                                alignment: Alignment.bottomCenter,
                                                            ),
                                                            SizedBox(
                                                                height: 15.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('PRIVACY_HEADING_ROW_3'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18.0,
                                                                                fontWeight: FontWeight.w700,
                                                                                letterSpacing: 1.1,
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                            SizedBox(
                                                                height: 15.0
                                                            ),
                                                            Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: <Widget>[
                                                                    Flexible(
                                                                        child: Text(
                                                                            AppLocalizations.of(context).translate('PRIVACY_TEXT_ROW_3'),
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 15.0,
                                                                                fontWeight: FontWeight.w400
                                                                            ),
                                                                            textAlign: TextAlign.center,
                                                                        ),
                                                                    )
                                                                ],
                                                            ),
                                                            SizedBox(
                                                                height: 50.0
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
