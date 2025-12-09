import 'package:flutter/material.dart';
import '../../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final String statsText;
  final VoidCallback onTap;
  final List<bool> completionGrid;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.statsText,
    required this.onTap,
    required this.completionGrid,
  });

  Color _getCardColor() {
    if (activity.backgroundColor != null) {
      return Color(int.parse(activity.backgroundColor!.replaceFirst('#', '0xFF')));
    }
    return Colors.grey.shade100;
  }

  Color _getBorderColor() {
    switch (activity.type) {
      case ActivityType.timedActivity:
        return const Color(0xFFE8B4F8);
      case ActivityType.simpleTally:
        return const Color(0xFFFF6B6B);
      case ActivityType.measuredTally:
        return const Color(0xFF4A90E2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getCardColor(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getBorderColor(),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getBorderColor().withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  activity.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Activity info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statsText,
                    style: TextStyle(
                      fontSize: 14,
                      color: _getBorderColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // Calendar grid
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return SizedBox(
      width: 80,
      height: 56,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: 21,
        itemBuilder: (context, index) {
          final isCompleted = index < completionGrid.length && completionGrid[index];
          return Container(
            decoration: BoxDecoration(
              color: isCompleted
                  ? _getBorderColor().withOpacity(0.8)
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        },
      ),
    );
  }
}