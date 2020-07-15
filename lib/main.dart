import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:xlive_switch/xlive_switch.dart';

import 'package:NOVID_19/helper/localization.dart';
import 'package:NOVID_19/theme/colors/dark_colors.dart';
import 'package:NOVID_19/service/exposure_notification.dart';
import 'package:NOVID_19/widgets/activity_card.dart';
import 'package:NOVID_19/widgets/info_column.dart';
import 'package:NOVID_19/widgets/logo_column.dart';
import 'package:NOVID_19/widgets/top_container.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            supportedLocales: [
                Locale('de')
            ],
            localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'NOVID-19',
            theme: ThemeData(
                brightness: Brightness.dark,
                visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: NOVID(),
        );
    }
}

class NOVID extends StatefulWidget {
    @override
    _NOVIDState createState() => _NOVIDState();
}

class _NOVIDState extends State<NOVID> with SingleTickerProviderStateMixin {
    ExposureNotificationDiscovery _notificationDiscovery = new ExposureNotificationDiscovery();
    Timer _timer;
    List exposureDevices = [];
    int _exposureDevicesCount = 0;
    double _lowestDistance = 0.00;
    bool scannerState = true;
    bool scannerInitialized = false;

    Text subheading(String title) {
        return Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2),
        );
    }

    @override
    void initState() {
        super.initState();
        initNotificationDiscovery();
    }

    Future<void> initNotificationDiscovery() async {
        Timer.periodic(Duration(seconds: 15), (_timer) async {
            if (scannerState) {
                if (!scannerInitialized) {
                    _notificationDiscovery.init();
                    scannerInitialized = true;
                }
                exposureDevices = await _notificationDiscovery.getTodaysExposures();
                double lowestDistance = await _notificationDiscovery.getTodaysLowestDistance();
                setState(() {
                    _exposureDevicesCount = exposureDevices.length;
                    _lowestDistance = lowestDistance;
                });
            } else if(scannerInitialized && !scannerState) {
                _notificationDiscovery.dispose();
                scannerInitialized = false;
            }
        });
    }

    @override
    void deactivate() {
        print("deactivate");
        _notificationDiscovery.deactivate();
        super.deactivate();
    }

    @override
    void reassemble() {
        print("reassemble");
        _notificationDiscovery.refresh();
        super.reassemble();
    }

    @override
    void dispose() {
        _notificationDiscovery.dispose();
        _timer.cancel();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        return Scaffold(
            backgroundColor: DarkColors.primary,
            body: SafeArea(
                child: Column(
                    children: <Widget>[
                        TopContainer(
                            height: 130,
                            width: width,
                            color: DarkColors.secondary,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                            LogoColumn(
                                                image: "assets/icon/icon.png",
                                                imageBackgroundColor: Colors.transparent,
                                                title: AppLocalizations.of(context).translate('HEADER_TITLE'),
                                                subtitle: AppLocalizations.of(context).translate('HEADER_SUBTITLE')
                                            ),
                                        ],
                                    ),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            Text(
                                                AppLocalizations.of(context).translate('SCANNER_STATUS_TITLE'),
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w800,
                                                ),
                                            ),
                                            XlivSwitch(
                                                value: scannerState,
                                                activeColor: DarkColors.success,
                                                unActiveColor: DarkColors.danger,
                                                onChanged: (bool state) {
                                                    setState(() {
                                                        scannerState = state;
                                                    });
                                                },
                                            ),
                                        ],
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 0.0
                                        ),
                                        child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[],
                                        ),
                                    )
                                ]
                            ),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                                child: Column(
                                    children: <Widget>[
                                        Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10.0),
                                            child: Column(
                                                children: <Widget>[
                                                    SizedBox(
                                                        height: 25.0
                                                    ),
                                                    Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                            Expanded(
                                                                child: Container(
                                                                    margin: const EdgeInsets.only(right: 10.0),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                    )
                                                                ),
                                                            ),
                                                            subheading(AppLocalizations.of(context).translate('STATISTICS')),
                                                            Expanded(
                                                                child: Container(
                                                                    margin: const EdgeInsets.only(left: 10.0),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                    )
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                    SizedBox(
                                                        height: 15.0
                                                    ),
                                                    InfoColumn(
                                                        icon: Icons.fingerprint,
                                                        iconBackgroundColor: DarkColors.success,
                                                        title: AppLocalizations.of(context).translate('COLLECTED_IDENTIFIER'),
                                                        subtitle: "$_exposureDevicesCount",
                                                    ),
                                                    SizedBox(
                                                        height: 15.0,
                                                    ),
                                                    InfoColumn(
                                                        icon: Icons.pan_tool,
                                                        iconBackgroundColor: DarkColors.warning,
                                                        title: AppLocalizations.of(context).translate('CLOSEST_DISTANCE'),
                                                        subtitle: "$_lowestDistance m",
                                                    ),
                                                    SizedBox(
                                                        height: 15.0
                                                    ),
                                                    InfoColumn(
                                                        icon: Icons.warning,
                                                        iconBackgroundColor: DarkColors.danger,
                                                        title: AppLocalizations.of(context).translate('LONGER_CONTACTS'),
                                                        subtitle: '0',
                                                    ),
                                                ],
                                            ),
                                        ),
                                        Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10.0),
                                            child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                    SizedBox(height: 25.0),
                                                    Row(
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                            Expanded(
                                                                child: Container(
                                                                    margin: const EdgeInsets.only(right: 10.0),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                    )
                                                                ),
                                                            ),
                                                            subheading(AppLocalizations.of(context).translate('ACTIVE_CONTACTS')),
                                                            Expanded(
                                                                child: Container(
                                                                    margin: const EdgeInsets.only(left: 10.0),
                                                                    child: Divider(
                                                                        color: Colors.white,
                                                                    )
                                                                ),
                                                            ),
                                                        ],
                                                    ),
                                                    SizedBox(height: 15.0),
                                                    Row(
                                                        children: <Widget>[
                                                            ActivityCard(
                                                                cardColor: DarkColors.secondary,
                                                                progressPrimaryColor: DarkColors.danger,
                                                                progressSecondaryColor: DarkColors.primary,
                                                                loadingPercent: 1,
                                                                title: '12:34:45:67:89',
                                                                subtitle: '15 Minuten',
                                                            ),
                                                            SizedBox(
                                                                width: 20.0
                                                            ),
                                                            ActivityCard(
                                                                cardColor: DarkColors.secondary,
                                                                progressPrimaryColor: DarkColors.warning,
                                                                progressSecondaryColor: DarkColors.primary,
                                                                loadingPercent: 0.79,
                                                                title: '12:34:45:67:89',
                                                                subtitle: '13 Minuten!',
                                                            ),
                                                        ],
                                                    ),
                                                    SizedBox(height: 15.0),
                                                    Row(
                                                        children: <Widget>[
                                                            ActivityCard(
                                                                cardColor: DarkColors.secondary,
                                                                progressPrimaryColor: DarkColors.success,
                                                                progressSecondaryColor: DarkColors.primary,
                                                                loadingPercent: 0.39,
                                                                title: '12:34:45:67:89',
                                                                subtitle: '6 Minuten',
                                                            ),
                                                            SizedBox(
                                                                width: 20.0
                                                            ),
                                                            ActivityCard(
                                                                cardColor: DarkColors.secondary,
                                                                progressPrimaryColor: DarkColors.success,
                                                                progressSecondaryColor: DarkColors.primary,
                                                                loadingPercent: 0.3,
                                                                title: '12:34:45:67:89',
                                                                subtitle: '5 Minuten!',
                                                            ),
                                                        ],
                                                    )
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
        );
    }
}
