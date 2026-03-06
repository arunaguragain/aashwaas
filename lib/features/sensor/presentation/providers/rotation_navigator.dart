import 'dart:async';
import 'dart:ui';

import 'package:sensors_plus/sensors_plus.dart';

class RotationNavigator {
  RotationNavigator({
    required this.onNext,
    required this.onPrevious,
    this.threshold = 2.0,
    this.debounce = const Duration(milliseconds: 500),
  });

  final VoidCallback onNext;

  final VoidCallback onPrevious;

  final double threshold;

  final Duration debounce;

  StreamSubscription<GyroscopeEvent>? _sub;
  Timer? _debounceTimer;

  void start() {
    _sub ??= gyroscopeEvents.listen(_onEvent);
  }

  void stop() {
    _sub?.cancel();
    _sub = null;
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }

  void _onEvent(GyroscopeEvent e) {
    if (_debounceTimer != null) return;

    if (e.z > threshold) {
      onNext();
      _startDebounce();
    } else if (e.z < -threshold) {
      onPrevious();
      _startDebounce();
    }
  }

  void _startDebounce() {
    _debounceTimer = Timer(debounce, () {
      _debounceTimer = null;
    });
  }
}
