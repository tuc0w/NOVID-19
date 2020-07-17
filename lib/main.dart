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
// ui
import 'package:NOVID_19/theme/colors/dark_colors.dart';
import 'package:NOVID_19/widgets/info_column.dart';
import 'package:NOVID_19/widgets/logo_column.dart';
import 'package:NOVID_19/widgets/top_container.dart';
import 'package:xlive_switch/xlive_switch.dart';
// novid
import 'package:NOVID_19/data/database.dart';
import 'package:NOVID_19/helper/localization.dart';
import 'package:NOVID_19/helper/time.dart';
import 'package:NOVID_19/service/render_activity.dart';
import 'package:NOVID_19/service/exposure_notification.dart';

part 'package:NOVID_19/isolates/database.dart';
part 'package:NOVID_19/novid19.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) => runApp(Novid19()));
}
