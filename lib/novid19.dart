// platform
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// database
import 'package:moor/isolate.dart';
import 'package:moor/moor.dart' as Room;
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
// helper
import 'package:NOVID_19/helper/math.dart';
import 'package:rxdart/rxdart.dart';
// ui
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:NOVID_19/theme/colors/dark_colors.dart';
import 'package:NOVID_19/widgets/info_column.dart';
import 'package:NOVID_19/widgets/logo_column.dart';
import 'package:NOVID_19/widgets/subheading.dart';
import 'package:NOVID_19/widgets/top_container.dart';
import 'package:xlive_switch/xlive_switch.dart';
// novid
import 'package:NOVID_19/data/database.dart';
import 'package:NOVID_19/helper/localization.dart';
import 'package:NOVID_19/helper/time.dart';
import 'package:NOVID_19/service/render_activity.dart';
import 'package:NOVID_19/service/exposure_notification.dart';

// screens
import 'package:NOVID_19/credits.dart';

part 'package:NOVID_19/isolates/database.dart';
part 'package:NOVID_19/part/novid19.dart';

class Novid19Screen extends StatelessWidget {
    static String tag = 'novid19-screen';

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: MaterialApp(
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
                home: Novid(),
            )
        );
    }
}

class Novid extends StatefulWidget {
    @override
    _NovidState createState() => _NovidState();
}
