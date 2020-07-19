part of 'main.dart';

class Novid19 extends StatelessWidget {
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
            home: Novid(),
        );
    }
}

class Novid extends StatefulWidget {
    @override
    _NovidState createState() => _NovidState();
}

class _NovidState extends State<Novid> with SingleTickerProviderStateMixin {
    Database _database;
    ExposureNotificationDiscovery _notificationDiscovery = new ExposureNotificationDiscovery();
    MoorIsolate _databaseIsolate;
    StreamSubscription _activeContactsSubscription;
    StreamSubscription _uniqueContactsSubscription;
    StreamSubscription _lowestDistanceSubscription;
    StreamSubscription _longestContactsSubscription;

    /// ui states
    List exposureDevices = [];
    int _exposureDevicesCount = 0;
    double _lowestDistance = 0.00;
    int _longestContacts = 0;
    Widget _recentActivity;
    static const _infoUpdateDuration = Duration(seconds: 12);
    static const _activityUpdateDuration = Duration(seconds: 15);
    double _distanceThreshold = 2.0;

    // bl states
    Timer _timer;
    bool scannerState = true;
    bool scannerInitialized = false;
    int _lastScannerUpdate;

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
        _initDatabseIsolate();
        _initNotificationDiscovery();
    }

    Future<void> _initDatabseIsolate() async {
        _databaseIsolate = await _createMoorIsolate();
        Room.DatabaseConnection connection = await _databaseIsolate.connect();
        _database = Database.connect(connection);
        _initDatabaseStreams();
    }

    Future<void> _initDatabaseStreams() async {
        _activeContactsSubscription = Stream
            .periodic(_activityUpdateDuration)
            .switchMap((_) {
                return _database.watchAllContacts(
                    from: getTimeOneHourAgo(),
                    to: DateTime.now()
                );
            })
            .listen((contactsWithNotifications) {
                setState(() {
                    _recentActivity = RenderActivity(context, contactsWithNotifications);
                });
            });
        
        _uniqueContactsSubscription = Stream
            .periodic(_infoUpdateDuration)
            .switchMap((_) {
                return _database.watchUniqueContacts(
                    from: getLastMidnight(),
                    to: getCurrentDateTime()
                );
            })
            .listen((uniqueContacts) {
                setState(() {
                    _exposureDevicesCount = uniqueContacts.length;
                });
            });
        
        _lowestDistanceSubscription = Stream
            .periodic(_infoUpdateDuration)
            .switchMap((_) {
                return _database.watchLowestExposureDistance(
                    from: getLastMidnight(),
                    to: getCurrentDateTime()
                );
            })
            .listen((lowestDistance) {
                setState(() {
                    _lowestDistance = roundDouble(calculateDistance(lowestDistance.rssi) ?? 0.00, 2);
                });
            });
        
        _longestContactsSubscription = Stream
            .periodic(_infoUpdateDuration)
            .switchMap((_) {
                return _database.watchAllContacts(
                    from: getLastMidnight(),
                    to: getCurrentDateTime()
                );
            })
            .listen((allContacts) {
                int tempLongestContacts = 0;
                allContacts.forEach((element) {
                    if (
                        element.notifications.isNotEmpty &&
                        element.notifications.length > 1
                    ) {
                        final firstNotificationDate = element.notifications.first.date;
                        final lastNotificationDate = element.notifications.last.date;
                        Duration difference = lastNotificationDate.difference(firstNotificationDate);

                        if (difference.inSeconds >= 180) {
                            final rssiToContact = {for (var notification in element.notifications) notification.id: notification.rssi};
                            final rssis = rssiToContact.values;
                            final int averageRssi = (rssis.reduce((a, b) => a + b) / rssis.length).round();
                            final double averageDistance = roundDouble(calculateDistance(averageRssi), 2);

                            if (averageDistance <= _distanceThreshold) {
                                tempLongestContacts++;
                            }
                        }
                    }
                });

                setState(() {
                    _longestContacts = tempLongestContacts;
                });
            });
    }

    Future<void> _initNotificationDiscovery() async {
        Timer.periodic(Duration(seconds: 12), (_timer) async {
            if (scannerState) {
                if (!scannerInitialized) {
                    await _notificationDiscovery.initDatabase(_database);
                    await _notificationDiscovery.initBleManager();
                    scannerInitialized = true;
                }
                int tempLastScannerUpdate = await _notificationDiscovery.getLastUpdate();
                setState(() {
                    _lastScannerUpdate = tempLastScannerUpdate;
                });
            } else if(scannerInitialized && !scannerState) {
                _notificationDiscovery.dispose();
                scannerInitialized = false;
            }
        });
    }

    @override
    void deactivate() {
        _notificationDiscovery.deactivate();
        super.deactivate();
    }

    @override
    void dispose() {
        _notificationDiscovery?.dispose();
        _timer?.cancel();
        _activeContactsSubscription?.cancel();
        _uniqueContactsSubscription?.cancel();
        _lowestDistanceSubscription?.cancel();
        _longestContactsSubscription?.cancel();
        _databaseIsolate?.shutdownAll();
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
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            Text(
                                                AppLocalizations.of(context).translate('SCANNER_STATUS_UPDATE'),
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                ),
                                            ),
                                            Text(
                                                "$_lastScannerUpdate ${AppLocalizations.of(context).translate('SECONDS')}",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w400,
                                                ),
                                            )
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
                                                        subtitle: ((_exposureDevicesCount == 0) ? "0" : "$_exposureDevicesCount"),
                                                    ),
                                                    SizedBox(
                                                        height: 15.0,
                                                    ),
                                                    InfoColumn(
                                                        icon: Icons.pan_tool,
                                                        iconBackgroundColor: DarkColors.warning,
                                                        title: AppLocalizations.of(context).translate('CLOSEST_DISTANCE'),
                                                        subtitle: ((_lowestDistance == 0) ? "0" : "$_lowestDistance m"),
                                                    ),
                                                    SizedBox(
                                                        height: 15.0
                                                    ),
                                                    InfoColumn(
                                                        icon: Icons.warning,
                                                        iconBackgroundColor: DarkColors.danger,
                                                        title: AppLocalizations.of(context).translate('LONGER_CONTACTS'),
                                                        subtitle: ((_longestContacts == 0) ? "0" : "$_longestContacts"),
                                                    ),
                                                ],
                                            ),
                                        ),
                                        Container(
                                            color: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10.0
                                            ),
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
                                                    _recentActivity ?? Text(AppLocalizations.of(context).translate('LOADING')),
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
