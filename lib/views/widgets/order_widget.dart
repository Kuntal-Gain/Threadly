// 📁 order_timeline.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A single step in the timeline.
class OrderStep {
  final String label;
  final DateTime time;
  final bool isDone;

  OrderStep({
    required this.label,
    required this.time,
    this.isDone = false,
  });
}

/// Top‑level widget
class OrderTimeline extends StatelessWidget {
  final List<OrderStep> steps;

  const OrderTimeline({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---- LEFT COLUMN (dot + connector) ----
            Column(
              children: [
                // dot
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: step.isDone
                        ? Colors.black
                        : Colors.grey.shade300, // light grey
                  ),
                  child: step.isDone
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),

                // connector line (skip after last dot)
                if (!isLast)
                  Container(
                    width: 2,
                    height: 64, // tweak spacing between dots
                    color: steps[index + 1].isDone
                        ? Colors.black
                        : Colors.grey.shade300,
                  ),
              ],
            ),

            const SizedBox(width: 12),

            /// ---- RIGHT COLUMN (text) ----
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMMM yyyy, hh:mm a').format(step.time),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
