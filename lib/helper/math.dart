import 'dart:math';

/// Constants used for distance calculation.
const num measuredPower = -72.0; // the expected RSSI at a distance of 1 meter
const num broadcastingPower = 3.9; // the broadcasting power is around 2-4 dBm

/// Calculates the approximate distance.
///
/// Distance = 10 ^ ((Measured Power - RSSI)/(10 * N))
/// Measured Power = -75
/// N = 3.9 (Consider high signal strength)
/// ```dart
/// calculateDistance(-80) == 1.34
/// ```
/// Returns the distance in meters.
double calculateDistance(int rssi) {
    num result = 0.00;
    if (rssi != null) {
        result = pow(10, ((measuredPower - (rssi))/(10 * broadcastingPower)));
    }

    return result;
}

double roundDouble(double value, int places){ 
    double mod = pow(10.0, places); 
    return ((value * mod).round()?.toDouble() ?? 0.00 / mod); 
}
