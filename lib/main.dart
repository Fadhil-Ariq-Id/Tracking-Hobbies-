import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'viewmodels/activity_viewmodel.dart';
import 'views/screens/activities_screen.dart';
import 'views/screens/select_activity_screen.dart';
import 'views/screens/create_activity_screen.dart';
import 'models/activity.dart';
import 'services/sample_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SampleData.initializeSampleData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActivityViewModel()),
      ],
      child: MaterialApp.router(
        title: 'TimeSpent',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
        ),
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ActivitiesScreen(),
    ),
    GoRoute(
      path: '/select-activity',
      builder: (context, state) => const SelectActivityScreen(),
    ),
    GoRoute(
      path: '/create-activity',
      builder: (context, state) {
        final activityType = state.extra as ActivityType;
        return CreateActivityScreen(activityType: activityType);
      },
    ),
  ],
);