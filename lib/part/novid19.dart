part of '../novid19.dart';

class _NovidState extends State<Novid> with SingleTickerProviderStateMixin {
    Database _database;
    ExposureNotificationDiscovery _notificationDiscovery = new ExposureNotificationDiscovery();
    MoorIsolate _databaseIsolate;

    // streams
    StreamSubscription _activeContactsSubscription;
    StreamSubscription _uniqueContactsSubscription;
    StreamSubscription _lowestDistanceSubscription;
    StreamSubscription _longestContactsSubscription;

    /// ui states
    final GlobalKey<FabCircularMenuState> _fabKey = GlobalKey();
    List exposureDevices = [];
    int _exposureDevicesCount = 0;
    double _lowestDistance = 0.00;
    int _longestContacts = 0;
    Widget _recentActivity;
    bool _dontAskAgainForBatteryPermissions = false;

    // thresholds
    double _distanceThreshold = 2.0;

    // update durations
    static const _activityUpdateDuration = Duration(seconds: 15);
    static const _infoUpdateDuration = Duration(seconds: 6);
    static const _notificationDiscoveryUpdateDuration = Duration(seconds: 12);

    /// ble states
    Timer _timer;
    bool scannerState = true;
    bool scannerInitialized = false;
    int _lastScannerUpdate;

    @override
    void initState() {
        super.initState();
        _initDatabseIsolate();
        _initNotificationDiscovery();
        _checkBatteryPermissions();
    }

    Future<void> _initDatabseIsolate() async {
        _databaseIsolate = await _createMoorIsolate();
        Room.DatabaseConnection connection = await _databaseIsolate.connect();
        _database = Database.connect(connection);
        _initDatabaseStreams();
    }

    Future<void> _initDatabaseStreams() async {
        _activeContactsSubscription = Rx
            .concat<Null>([
                Stream.value(null),
                Stream.periodic(_activityUpdateDuration),
            ])
            .switchMap((_) {
                return _database.watchAllContacts(
                    from: getTimeOneHourAgo(),
                    to: getCurrentDateTime()
                );
            })
            .listen((contactsWithNotifications) {
                setState(() {
                    _recentActivity = RenderActivity(context, contactsWithNotifications);
                });
            });
        

        _uniqueContactsSubscription = Rx
            .concat<Null>([
                Stream.value(null),
                Stream.periodic(_infoUpdateDuration),
            ])
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
        
        
        _lowestDistanceSubscription = Rx
            .concat<Null>([
                Stream.value(null),
                Stream.periodic(_infoUpdateDuration),
            ])
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
        

        _longestContactsSubscription = Rx
            .concat<Null>([
                Stream.value(null),
                Stream.periodic(_infoUpdateDuration),
            ])
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
        Timer.periodic(_notificationDiscoveryUpdateDuration, (_timer) async {
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

    void _onBatteryDialogValueChange(bool state) async {
        await SharedPreferences.getInstance().then((prefs) {
            prefs.setBool('battery_dont_ask', state);
        });
    }

    void _displayBatteryDialog() async {
        return showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                title: Text(AppLocalizations.of(context).translate('BATTERY_DIALOG_TITLE')),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Flexible(
                                    child: Text(
                                        AppLocalizations.of(context).translate('BATTERY_DIALOG_QUESTION'),
                                        textAlign: TextAlign.center,
                                    ),
                                )
                            ],
                        ),
                        CheckboxListTile(
                            title: Text(AppLocalizations.of(context).translate('BATTERY_DIALOG_CHECKBOX')),
                            value: _dontAskAgainForBatteryPermissions,
                            onChanged: (bool value) {
                                setState(() {
                                    _dontAskAgainForBatteryPermissions = value;
                                    _onBatteryDialogValueChange(value);
                                });
                            },
                        ),
                    ],
                ),
                actions: <Widget>[
                    FlatButton(
                        child: new Text(
                            AppLocalizations.of(context).translate('BATTERY_DIALOG_CANCEL'),
                            textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                            Navigator.of(context).pop();
                        },
                    ),
                    FlatButton(
                        child: new Text(
                            AppLocalizations.of(context).translate('BATTERY_DIALOG_OK'),
                            textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                            BatteryOptimization.openBatteryOptimizationSettings();
                        },
                    )
                ],
            )
        );
    }

    Future<void> _checkBatteryPermissions() async {
        await SharedPreferences.getInstance().then((prefs) {
            _dontAskAgainForBatteryPermissions = prefs.getBool('battery_dont_ask') ?? false;
        });

        if (Platform.isAndroid && !_dontAskAgainForBatteryPermissions) {
            BatteryOptimization.isIgnoringBatteryOptimizations().then((isIgnoringBatteryOptimization) {
                if (!isIgnoringBatteryOptimization) {
                    _displayBatteryDialog();
                }
            });
        }
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

        return WillPopScope(
            child: Scaffold(
                backgroundColor: DarkColors.primary,
                body: SafeArea(
                    child: Column(
                        children: <Widget>[
                            TopContainer(
                                height: 150,
                                width: width,
                                color: DarkColors.secondary,
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
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
                                                        ((_lastScannerUpdate != null) ? "$_lastScannerUpdate ${AppLocalizations.of(context).translate('SECONDS')}" : AppLocalizations.of(context).translate('LOADING')),
                                                        style: TextStyle(
                                                            color: Colors.white70,
                                                            fontSize: 15.0,
                                                            fontWeight: FontWeight.w400,
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ]
                                    ),
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
                                                                Subheading(color: Colors.white, title: AppLocalizations.of(context).translate('STATISTICS')),
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
                                                            subtitle: ((_exposureDevicesCount == 0) ? AppLocalizations.of(context).translate('LOADING') : "$_exposureDevicesCount"),
                                                        ),
                                                        SizedBox(
                                                            height: 15.0,
                                                        ),
                                                        InfoColumn(
                                                            icon: Icons.pan_tool,
                                                            iconBackgroundColor: DarkColors.warning,
                                                            title: AppLocalizations.of(context).translate('CLOSEST_DISTANCE'),
                                                            subtitle: ((_lowestDistance == 0) ? AppLocalizations.of(context).translate('LOADING') : "$_lowestDistance m"),
                                                        ),
                                                        SizedBox(
                                                            height: 15.0
                                                        ),
                                                        InfoColumn(
                                                            icon: Icons.warning,
                                                            iconBackgroundColor: DarkColors.danger,
                                                            title: AppLocalizations.of(context).translate('LONGER_CONTACTS'),
                                                            subtitle: ((_longestContacts == 0) ? AppLocalizations.of(context).translate('LOADING') : "$_longestContacts"),
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
                                                                Subheading(color: Colors.white, title: AppLocalizations.of(context).translate('ACTIVE_CONTACTS')),
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
                floatingActionButton: FabCircularMenu(
                    animationCurve: Curves.easeInOutCirc,
                    animationDuration: const Duration(milliseconds: 300),
                    fabColor: DarkColors.secondary,
                    fabOpenIcon: Icon(Icons.menu, color: Colors.white),
                    fabCloseIcon: Icon(Icons.close, color: Colors.white),
                    key: _fabKey,
                    ringColor: Colors.white.withAlpha(30),
                    ringDiameter: 360.0,
                    ringWidth: 72.0,
                    children: <Widget>[
                        RawMaterialButton(
                            child: FaIcon(FontAwesomeIcons.trophy, color: Colors.white),
                            onPressed: () {
                                _fabKey.currentState.close();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreditsScreen()
                                    ),
                                );
                            },
                            padding: const EdgeInsets.all(24.0),
                            shape: CircleBorder(),
                        ),
                        RawMaterialButton(
                            child: FaIcon(FontAwesomeIcons.userShield, color: Colors.white),
                            onPressed: () {
                                _fabKey.currentState.close();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrivacyScreen()
                                    ),
                                );
                            },
                            padding: const EdgeInsets.all(24.0),
                            shape: CircleBorder(),
                        ),
                    ],
                ),
            ),
            onWillPop: () async => false,
        );
    }
}
