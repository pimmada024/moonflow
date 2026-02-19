import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFBFDDE4),
              Color(0xFFCFA8E6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Settings",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A008A),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  children: [
                    _settingItem(
                      icon: Icons.person,
                      title: "Profile",
                      subtitle: "Edit your profile information",
                    ),
                    const SizedBox(height: 12),
                    _settingItem(
                      icon: Icons.notifications,
                      title: "Notifications",
                      subtitle: "Manage notification preferences",
                    ),
                    const SizedBox(height: 12),
                    _settingItem(
                      icon: Icons.privacy_tip,
                      title: "Privacy",
                      subtitle: "Privacy and security settings",
                    ),
                    const SizedBox(height: 12),
                    _settingItem(
                      icon: Icons.help,
                      title: "Help & Support",
                      subtitle: "Get help and support",
                    ),
                    const SizedBox(height: 12),
                    _settingItem(
                      icon: Icons.info,
                      title: "About",
                      subtitle: "Version 1.0.0",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF06C8C), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
