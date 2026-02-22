import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Provides a stream of [AccelerometerEvent] from the device sensors.
///
/// Usage: `final event = ref.watch(accelerometerProvider);`
final accelerometerProvider =
    StreamProvider.autoDispose<AccelerometerEvent>((ref) {
  // The plugin exposes a broadcast stream of accelerometer events.
  return accelerometerEvents;
});
