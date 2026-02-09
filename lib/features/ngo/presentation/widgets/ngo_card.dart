import 'package:aashwaas/features/ngo/domain/entities/ngo_entity.dart';
import 'package:aashwaas/features/ngo/presentation/widgets/ngo_badge.dart';
import 'package:aashwaas/features/ngo/presentation/widgets/ngo_image.dart';
import 'package:aashwaas/features/ngo/presentation/widgets/ngo_info_row.dart';
import 'package:flutter/material.dart';

class NgoCard extends StatelessWidget {
  final NgoEntity ngo;

  const NgoCard({super.key, required this.ngo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showNgoDetails(context),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      NgoImage(
                        photo: ngo.photo,
                        width: double.infinity,
                        height: 140,
                      ),
                      Positioned(
                        left: 10,
                        top: 10,
                        child: NgoBadge(
                          label: 'NGO',
                          background: const Color(0xFF1F1F1F),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 10,
                        child: NgoBadge(
                          label: 'Verified',
                          icon: Icons.verified,
                          background: const Color(0xFF2EAD63),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        ngo.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Reg: ${ngo.registrationNumber}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 10),
                NgoInfoRow(icon: Icons.person_outline, text: ngo.contactPerson),
                const SizedBox(height: 12),
                NgoInfoRow(icon: Icons.phone, text: ngo.phone),
                const SizedBox(height: 6),
                NgoInfoRow(icon: Icons.mail_outline, text: ngo.email),
                const SizedBox(height: 6),
                NgoInfoRow(icon: Icons.location_on_outlined, text: ngo.address),
                if (ngo.focusAreas.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ngo.focusAreas
                        .map(
                          (area) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF4FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              area,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF356AE6),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNgoDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: NgoImage(photo: ngo.photo, width: 140, height: 140),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ngo.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Reg: ${ngo.registrationNumber}'),
                  const SizedBox(height: 12),
                  NgoInfoRow(
                    icon: Icons.person_outline,
                    text: ngo.contactPerson,
                  ),
                  const SizedBox(height: 8),
                  NgoInfoRow(icon: Icons.phone, text: ngo.phone),
                  const SizedBox(height: 8),
                  NgoInfoRow(icon: Icons.mail_outline, text: ngo.email),
                  const SizedBox(height: 8),
                  NgoInfoRow(
                    icon: Icons.location_on_outlined,
                    text: ngo.address,
                  ),
                  if (ngo.focusAreas.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Focus Areas',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ngo.focusAreas
                          .map(
                            (area) => Chip(
                              label: Text(area),
                              backgroundColor: const Color(0xFFEFF4FF),
                              labelStyle: const TextStyle(
                                color: Color(0xFF356AE6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
