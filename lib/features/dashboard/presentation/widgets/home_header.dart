import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onNotificationPressed;
  final VoidCallback onMenuPressed;
  final String? profileImageUrl;
  final bool isVerified;
  final String role;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.onNotificationPressed,
    required this.onMenuPressed,
    this.profileImageUrl,
    required this.isVerified,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? Icon(Icons.person, size: 40, color: Colors.deepPurple)
                    : null,
              ),
              const SizedBox(width: 8),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isVerified)
                    Row(
                      children: [
                        Text(
                          role == 'donor'
                              ? 'Verified Donor'
                              : 'Verified Volunteer',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                      ],
                    ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: onNotificationPressed,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: onMenuPressed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
