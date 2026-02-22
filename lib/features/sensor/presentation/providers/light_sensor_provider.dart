import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_sensor/light_sensor.dart';

/// Provides a stream of ambient light lux values from the device.
///
/// Usage: `final luxAsync = ref.watch(lightSensorProvider);`
final lightSensorProvider = StreamProvider.autoDispose<int>((ref) {
  // The plugin exposes a broadcast stream of integer lux values.
  return LightSensor.luxStream();
});
