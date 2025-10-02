import 'package:flutter/material.dart';
import '../theme.dart';

class TopHeaderSimple extends StatelessWidget {
  final VoidCallback? onMenuTap;
  final VoidCallback? onSupportTap;
  final VoidCallback? onContactTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  const TopHeaderSimple({
    super.key,
    this.onMenuTap,
    this.onSupportTap,
    this.onContactTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If there isn't enough width, hide the long text links
        final bool wide = constraints.maxWidth >= 520;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 18,
                offset: const Offset(0, 10),
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Logo / mark (replace with Image.asset if you have one)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Palette.sand,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.eco, color: Palette.forest, size: 20),
              ),

              const SizedBox(width: 14),

              const Text(
                'WELCOME',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 16,
                  color: Palette.forest,
                ),
              ),

              const Spacer(),

              // Only show these when there's room
              if (wide) ...[
                TextButton(
                  onPressed: onSupportTap ?? () {},
                  style: TextButton.styleFrom(foregroundColor: Palette.forest),
                  child: const Text('SUPPORT'),
                ),
                TextButton(
                  onPressed: onContactTap ?? () {},
                  style: TextButton.styleFrom(foregroundColor: Palette.forest),
                  child: const Text('NOUS JOINDRE'),
                ),
                const SizedBox(width: 6),
              ],

              // Action icons (always visible)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: onSettingsTap ?? () {},
                    icon: const Icon(Icons.settings, color: Palette.forest),
                  ),
                  IconButton(
                    tooltip: 'Logout',
                    onPressed: onLogoutTap ?? () {},
                    icon: const Icon(Icons.logout, color: Palette.forest),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: onMenuTap ?? () {},
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Palette.accent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.menu, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
