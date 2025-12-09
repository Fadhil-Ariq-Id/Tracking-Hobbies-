import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/activity.dart';
import '../widgets/activity_type_card.dart';

class SelectActivityScreen extends StatelessWidget {
  const SelectActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Select Activity',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ActivityTypeCard(
                title: 'Timed Activity',
                description: 'Unlimited sessions, unlimited possibilities.',
                type: ActivityType.timedActivity,
                examples: [
                  {'emoji': '📚', 'text': 'Reading', 'color': 'purple', 'bold': 'true'},
                  {'emoji': '•', 'text': '45m Today', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '🥊', 'color': 'black', 'bold': 'false'},
                  {'emoji': '', 'text': 'Muay Thai', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '75% W', 'color': 'black', 'bold': 'false'},
                  {'emoji': '🎬', 'text': 'Netflix', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '1h', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '🧘', 'color': 'black', 'bold': 'false'},
                  {'emoji': '', 'text': 'Meditation', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '45% Monthly G', 'color': 'black', 'bold': 'false'},
                ],
                onTap: () {
                  context.push('/create-activity', extra: ActivityType.timedActivity);
                },
              ),
              ActivityTypeCard(
                title: 'Simple Tally',
                description: 'Great for habits or simple activities.',
                type: ActivityType.simpleTally,
                examples: [
                  {'emoji': '💪', 'text': 'Pull-ups', 'color': 'red', 'bold': 'true'},
                  {'emoji': '•', 'text': '25 Today', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '🌅', 'color': 'black', 'bold': 'false'},
                  {'emoji': '', 'text': 'Alcohol-free Days', 'color': 'black', 'bold': 'false'},
                  {'emoji': '🎬', 'text': 'Clips Created', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '21 This Week', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '🌿', 'color': 'black', 'bold': 'false'},
                  {'emoji': '', 'text': 'Water Plant', 'color': 'black', 'bold': 'false'},
                ],
                onTap: () {
                  context.push('/create-activity', extra: ActivityType.simpleTally);
                },
              ),
              ActivityTypeCard(
                title: 'Measured Tally',
                description: 'For measurements beyond time.',
                type: ActivityType.measuredTally,
                examples: [
                  {'emoji': '🔻', 'text': 'Weighted Pull-ups', 'color': 'blue', 'bold': 'true'},
                  {'emoji': '•', 'text': '5 × 30kg', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '150kg Today', 'color': 'black', 'bold': 'false'},
                  {'emoji': '🥾', 'text': 'Hiking', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '9mi Today', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '🏋️', 'color': 'black', 'bold': 'false'},
                  {'emoji': '', 'text': 'Clean & Jerk', 'color': 'black', 'bold': 'false'},
                  {'emoji': '•', 'text': '3 × 10', 'color': 'black', 'bold': 'false'},
                ],
                onTap: () {
                  context.push('/create-activity', extra: ActivityType.measuredTally);
                },
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Inspiration',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Timed Activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildInspirationCard('🌿', const Color(0xFF81C784)),
                    _buildInspirationCard('📚', const Color(0xFF64B5F6)),
                    _buildInspirationCard('💀', const Color(0xFFE57373)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationCard(String emoji, Color color) {
    return Container(
      width: 100,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}