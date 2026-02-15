import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_status_badge.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_actions.dart';
import 'package:aashwaas/features/donation/domain/usecases/get_donation_by_id_usecase.dart';
import 'package:aashwaas/features/auth/data/datasources/remote/donor_auth_remote_datasource.dart';
import 'package:aashwaas/features/ngo/data/repositories/ngo_repository.dart';

class TaskCard extends ConsumerStatefulWidget {
  final TaskEntity task;
  final VoidCallback? onTap;
  final VoidCallback? onAccept;
  final VoidCallback? onComplete;
  final VoidCallback? onCancel;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onAccept,
    this.onComplete,
    this.onCancel,
  });

  @override
  ConsumerState<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  String? pickupLocation;
  String? donorContact;
  String? dropAddress;
  String? ngoContact;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadMappings();
  }

  Future<void> _loadMappings() async {
    setState(() => _loading = true);

    final donationId = widget.task.donationId;
    if (donationId.isNotEmpty) {
      try {
        final usecase = ref.read(getDonationByIdUsecaseProvider);
        final result = await usecase(
          GetDonationByIdParams(donationId: donationId),
        );
        result.fold((l) => null, (donation) async {
          if (!mounted) return;
          setState(() => pickupLocation = donation.pickupLocation);

          final donorId = donation.donorId;
          if (donorId != null && donorId.isNotEmpty) {
            try {
              final donorApi = await ref
                  .read(authDonorRemoteProvider)
                  .getDonorById(donorId);
              final contact = donorApi.phoneNumber ?? donorApi.email;
              if (mounted) setState(() => donorContact = contact);
            } catch (_) {}
          }
        });
      } catch (_) {}
    }

    final ngoId = widget.task.ngoId;
    if (ngoId != null && ngoId.isNotEmpty) {
      try {
        final ngoRepo = ref.read(ngoRepositoryProvider);
        final ngoRes = await ngoRepo.getNgoById(ngoId);
        ngoRes.fold((l) => null, (ngo) {
          if (!mounted) return;
          setState(() {
            dropAddress = ngo.address;
            ngoContact = (ngo.phone.isNotEmpty ? ngo.phone : ngo.email);
          });
        });
      } catch (_) {}
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = widget.task;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.place,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Pick up: ${pickupLocation ?? task.donationId}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_city,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Drop: ${dropAddress ?? task.ngoId ?? '-'}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Contact: ${donorContact ?? task.volunteerId}',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            if (ngoContact != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.contact_phone,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      'NGO: $ngoContact',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: TaskStatusBadge(status: task.status),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (task.assignedAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Assigned: ${task.assignedAt!.toLocal().toShortString()}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TaskActions(
                    onAccept: task.status == TaskStatus.assigned
                        ? widget.onAccept
                        : null,
                    onComplete: task.status == TaskStatus.accepted
                        ? widget.onComplete
                        : null,
                    onCancel: task.status == TaskStatus.assigned
                        ? widget.onCancel
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension _DateHelpers on DateTime {
  String toShortString() {
    return '${this.year}-${this.month.toString().padLeft(2, '0')}-${this.day.toString().padLeft(2, '0')}';
  }
}
