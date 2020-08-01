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
import 'package:CoTrack/helper/math.dart';
import 'package:rxdart/rxdart.dart';
// ui
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CoTrack/theme/colors/dark_colors.dart';
import 'package:CoTrack/widgets/info_column.dart';
import 'package:CoTrack/widgets/logo_column.dart';
import 'package:CoTrack/widgets/subheading.dart';
import 'package:CoTrack/widgets/top_container.dart';
import 'package:xlive_switch/xlive_switch.dart';
// novid
import 'package:CoTrack/data/database.dart';
import 'package:CoTrack/helper/localization.dart';
import 'package:CoTrack/helper/time.dart';
import 'package:CoTrack/service/render_activity.dart';
import 'package:CoTrack/service/exposure_notification.dart';

// screens
import 'package:CoTrack/credits.dart';
import 'package:CoTrack/privacy.dart';

part 'package:CoTrack/isolates/database.dart';
part 'package:CoTrack/part/cotrack.dart';

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
                title: 'CoTrack',
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
