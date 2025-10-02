import 'package:flutter/material.dart';
import '../theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Palette.deepGreen, Palette.forest]),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 28, 12, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(color: Color(0xFFD1D5DB)),
                    ),
                  ),
              ],
            ),
          ),
          if (actions != null) Row(children: actions!),
        ],
      ),
    );
  }
}
