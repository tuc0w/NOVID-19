import 'dart:async';
import 'dart:io';

import 'package:NOVID_19/helper/time.dart';
import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:NOVID_19/data/database.dart';
import 'package:NOVID_19/helper/math.dart';

class ExposureNotificationDiscovery {
    BleManager _bleManager = new BleManager();
    Database _database;
    PermissionStatus _locationPermissionStatus = PermissionStatus.unknown;
    StreamSubscription<ScanResult> _scanSubscription;

    List exposureDevices = [];
    int exposureDevicesCount = 0;
    double _distanceThreshold = 2.0;
    DateTime _lastUpdate = DateTime.now();

    void dispose() {
        _scanSubscription?.cancel();
        _bleManager.stopPeripheralScan();
    }

    Future<void> initBleManager() async {
        _bleManager
            .createClient()
            .catchError((e) => print("Couldn't create BLE client ${e.toString()}"))
            .then((_) => _checkPermissions())
            .catchError((e) => print("Permission check error ${e.toString()}"))
            .then((_) => _waitForBluetoothPoweredOn())
            .then((_) => _startExposureScan());
    }

    Future<void> initDatabase(Database database) async {
        _database = database;
    }

    Future<void> _waitForBluetoothPoweredOn() async {
        Completer completer = Completer();
        StreamSubscription<BluetoothState> subscription;
        subscription = _bleManager
            .observeBluetoothState(emitCurrentValue: true)
            .listen((bluetoothState) async {
            if (bluetoothState == BluetoothState.POWERED_ON &&
                !completer.isCompleted
            ) {
                await subscription.cancel();
                completer.complete();
            }
        });
        return completer.future;
    }

    Future<void> _checkPermissions() async {
        if (Platform.isAndroid) {
            var permissionStatus = await PermissionHandler()
                .requestPermissions([PermissionGroup.location]);

            _locationPermissionStatus = permissionStatus[PermissionGroup.location];

            if (_locationPermissionStatus != PermissionStatus.granted) {
                return Future.error(Exception("Location permission not granted"));
            }
        }
    }

    Future<void> _startExposureScan() async {
        _lastUpdate = DateTime.now();
        _scanSubscription =
            _bleManager.startPeripheralScan(
                uuids: [
                    "0000fd6f-0000-1000-8000-00805f9b34fb"
                ]
            ).listen((ScanResult scanResult) {
                String deviceId = scanResult.peripheral.identifier;
                int rssi = scanResult.rssi;
                double distance = calculateDistance(rssi);

                if (exposureDevices.isEmpty || !exposureDevices.contains(deviceId)) {
                    exposureDevices.add(deviceId);
                    _database.addDiscoveredContact(identifier: deviceId);
                } else if (exposureDevices.contains(deviceId)) {
                    distance = roundDouble(distance, 2);
                    if (distance <= _distanceThreshold) {
                        _database.addExposureNotification(
                            identifier: deviceId,
                            rssi: rssi,
                            from: getTimeOneHourAgo(),
                            to: getCurrentDateTime()
                        );
                    }
                }
            });
    }

    Future<int> getLastUpdate() async {
        Duration difference = getCurrentDateTime().difference(_lastUpdate);
        _lastUpdate = DateTime.now();
        return difference.inSeconds ?? 0;
    }

    Future<void> refresh() async {
        _scanSubscription.cancel();
        await _bleManager.stopPeripheralScan();
        await _checkPermissions()
            .then((_) => _startExposureScan())
            .catchError((e) => print("Couldn't refresh: ${e.toString()}"));
    }

    Future<void> deactivate() async {
        _scanSubscription.cancel();
        await _bleManager.stopPeripheralScan();
    }
}
