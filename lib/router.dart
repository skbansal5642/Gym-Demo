// router.dart
import 'package:go_router/go_router.dart';
import 'package:gym_demo/pages/add_set_screen.dart';
import 'package:gym_demo/pages/workout_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: '/',
      path: '/',
      builder: (context, state) => const WorkoutScreen(),
    ),
    GoRoute(
        name: '/add_set',
        path: '/add_set',
        builder: (context, state) {
          Map<String, dynamic> params = state.extra as Map<String, dynamic>;

          return AddSet(
            workoutSetList: params['workoutSetList']! as List<dynamic>,
            index: params['index'] != null ? params['index'] as int : null,
          );
        }),
  ],
);
