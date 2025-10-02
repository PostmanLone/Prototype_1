import 'package:flutter/material.dart';
import '../theme.dart';

class ProgressTimeline extends StatelessWidget {
  final List<String> steps;
  final int current; // 0-based
  const ProgressTimeline(
      {super.key, required this.steps, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i ~/ 2 < current ? Palette.forest : Palette.sand,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }
        final idx = i ~/ 2;
        final active = idx <= current;
        return Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Palette.forest : Colors.white,
            border: Border.all(
                color: active ? Palette.forest : Palette.sand, width: 2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check,
              size: 16, color: active ? Colors.white : Palette.sand),
        );
      }),
    );
  }
}
