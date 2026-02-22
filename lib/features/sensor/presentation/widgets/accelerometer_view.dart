import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../providers/accelerometer_provider.dart';

class AccelerometerView extends ConsumerWidget {
  const AccelerometerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncEvent = ref.watch(accelerometerProvider);

    return asyncEvent.when(
      data: (AccelerometerEvent event) => _buildData(event),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Sensor error: $e')),
    );
  }

  Widget _buildData(AccelerometerEvent e) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Accelerometer', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('x: ${e.x.toStringAsFixed(3)}'),
        Text('y: ${e.y.toStringAsFixed(3)}'),
        Text('z: ${e.z.toStringAsFixed(3)}'),
      ],
    );
  }
}
