import 'package:flutter/material.dart';
import '../../models/activity.dart';

class ActivityTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final ActivityType type;
  final List<Map<String, String>> examples;
  final VoidCallback onTap;

  const ActivityTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    required this.examples,
    required this.onTap,
  });

  Color _getBorderColor() {
    switch (type) {
      case ActivityType.timedActivity:
        return const Color(0xFF9B59B6);
      case ActivityType.simpleTally:
        return const Color(0xFFE74C3C);
      case ActivityType.measuredTally:
        return const Color(0xFF3498DB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _getBorderColor(),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 28,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Examples
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: examples.map((example) {
                return _buildExampleItem(example);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleItem(Map<String, String> example) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            example['emoji'] ?? '',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            example['text'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: example['color'] == 'purple'
                  ? const Color(0xFF9B59B6)
                  : example['color'] == 'red'
                      ? const Color(0xFFE74C3C)
                      : example['color'] == 'blue'
                          ? const Color(0xFF3498DB)
                          : Colors.black,
              fontWeight: example['bold'] == 'true' ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}