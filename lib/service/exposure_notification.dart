import 'dart:async';
import 'dart:io';

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
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

    Future _startExposureScan() async {
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
                    // we don't need to persist "contacts" the user encountered just once
                    // _database.addDiscoveredContact(identifier: deviceId);
                    print("New Peripheral ID: ${scanResult.peripheral.identifier}");
                } else if (exposureDevices.contains(deviceId)) {
                    distance = roundDouble(distance, 2);
                    print("Still in contact with: ${scanResult.peripheral.identifier}, distance: $distance");
                    if (distance <= _distanceThreshold) {
                        _database.addExposureNotification(identifier: deviceId, rssi: rssi);
                    }
                }
            });
    }

    Future<List> getAllExposures() async {
        return await _database.getUniqueExposureNotifications();
    }

    Future<List> getExposuresByDate({DateTime date}) async {
        return await _database.getUniqueExposureNotifications(
            date: date
        );
    }

    Future<List> getTodaysExposures() async {
        return await getExposuresByDate(
            date: new DateTime.now()
        );
    }

    Future<double> getLowestDistanceByDate({DateTime date}) async {
        int lowestRssi = await _database.getLowestExposureDistance(date: date);
        double distance = calculateDistance(lowestRssi);

        return roundDouble(distance ?? 0.00, 2);
    }

    Future<double> getLowestDistanceOfAllTime() async {
        int lowestRssi = await _database.getLowestExposureDistance();
        double distance = calculateDistance(lowestRssi);

        return roundDouble(distance ?? 0.00, 2);
    }

    Future<double> getTodaysLowestDistance() async {
        return await getLowestDistanceByDate(
            date: new DateTime.now()
        );
    }

    // Future<List> getTodaysContacts() async {
    //     final now = DateTime.now();
    //     final lastMidnight = new DateTime(now.year, now.month, now.day);
    //     final discoveredContacts = await _database.getConfirmedContactsByDate(
    //         from: lastMidnight, to: now
    //     );
    //     return discoveredContacts;
    // }

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
