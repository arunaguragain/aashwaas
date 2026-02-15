import 'package:flutter/material.dart';

class TaskActions extends StatelessWidget {
  final VoidCallback? onAccept;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const TaskActions({super.key, this.onAccept, this.onComplete, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (onAccept != null) {
      children.add(
        Flexible(
          flex: 2,
          child: SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: onAccept,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2EAD63)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Accept',
                style: TextStyle(color: Color(0xFF2EAD63)),
              ),
            ),
          ),
        ),
      );
    }

    if (onComplete != null) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 10));
      children.add(
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: onComplete,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF7B61FF)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Complete',
              style: TextStyle(color: Color(0xFF7B61FF)),
            ),
          ),
        ),
      );
    }

    if (onCancel != null) {
      if (children.isNotEmpty) children.add(const SizedBox(width: 8));
      children.add(
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF6B6B)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Decline',
              style: TextStyle(color: Color(0xFFFF6B6B)),
            ),
          ),
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
