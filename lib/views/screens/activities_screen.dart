import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/activity_viewmodel.dart';
import '../widgets/activity_card.dart';
import '../widgets/circular_action_button.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityViewModel>().loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 28),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    onPressed: () {
                      context.push('/select-activity');
                    },
                  ),
                ],
              ),
            ),
            // Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Activities List
            Expanded(
              child: Consumer<ActivityViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.activities.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No activities yet',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.push('/select-activity');
                            },
                            child: const Text('Add Your First Activity'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewModel.activities.length,
                    itemBuilder: (context, index) {
                      final activity = viewModel.activities[index];
                      return FutureBuilder<Map<String, dynamic>>(
                        future: viewModel.getActivityStats(activity.id!),
                        builder: (context, snapshot) {
                          final stats = snapshot.data ?? {};
                          final statsText = stats['thisWeek']?.toString() ?? '';
                          final entries = stats['entries'] as List? ?? [];
                          
                          // Generate completion grid (last 21 days)
                          final completionGrid = List.generate(21, (i) {
                            final date = DateTime.now().subtract(Duration(days: 20 - i));
                            return entries.any((e) {
                              final entryDate = e.date as DateTime;
                              return entryDate.year == date.year &&
                                  entryDate.month == date.month &&
                                  entryDate.day == date.day;
                            });
                          });

                          return Column(
                            children: [
                              ActivityCard(
                                activity: activity,
                                statsText: statsText.isNotEmpty
                                    ? '$statsText This Week'
                                    : 'No data',
                                onTap: () {
                                  // Navigate to activity detail
                                },
                                completionGrid: completionGrid,
                              ),
                              if (index == 0) ...[
                                const SizedBox(height: 24),
                                CircularActionButton(
                                  emoji: activity.emoji,
                                  text: 'START SESSION START SESSION START SESSION',
                                  onTap: () {
                                    // Start session
                                  },
                                  borderColor: const Color(0xFFE8B4F8),
                                ),
                                const SizedBox(height: 24),
                              ],
                              if (index == 1) ...[
                                const SizedBox(height: 24),
                                CircularActionButton(
                                  emoji: activity.emoji,
                                  text: 'ADD TALLY ADD TALLY ADD TALLY ADD TALLY',
                                  onTap: () {
                                    // Add tally
                                  },
                                  borderColor: const Color(0xFF81C784),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.wb_sunny_outlined, size: 28),
                onPressed: () {},
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Activities',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.hexagon_outlined, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 28),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}