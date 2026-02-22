import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';
class TiltLogoutDetector {
  TiltLogoutDetector({
    required this.onTiltDetected,
    this.thresholdDegrees = -30.0,
    this.sustainedDuration = const Duration(milliseconds: 700),
    this.debounce = const Duration(seconds: 2),
  });

  final void Function() onTiltDetected;
  final double thresholdDegrees;
  final Duration sustainedDuration;
  final Duration debounce;

  StreamSubscription<AccelerometerEvent>? _sub;
  Timer? _sustainTimer;
  DateTime? _lastTrigger;

  void start() {
    _sub ??= accelerometerEvents.listen(_onEvent);
  }

  void stop() {
    _sustainTimer?.cancel();
    _sustainTimer = null;
    _sub?.cancel();
    _sub = null;
  }

  void _onEvent(AccelerometerEvent event) {
    final roll = atan2(event.x, event.z) * 180 / pi;
    final now = DateTime.now();

    // If we're within debounce window, ignore
    if (_lastTrigger != null && now.difference(_lastTrigger!) <= debounce) {
      _sustainTimer?.cancel();
      _sustainTimer = null;
      return;
    }

    if (roll < thresholdDegrees) {
      // start sustain timer if not started
      _sustainTimer ??= Timer(sustainedDuration, () {
        _lastTrigger = DateTime.now();
        _sustainTimer = null;
        try {
          onTiltDetected();
        } catch (_) {}
      });
    } else {
      // tilt not sustained, cancel timer
      _sustainTimer?.cancel();
      _sustainTimer = null;
    }
  }
}
