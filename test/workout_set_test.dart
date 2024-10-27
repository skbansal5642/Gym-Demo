import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gym_demo/main.dart';
import 'package:gym_demo/models/workout_set.dart';
import 'package:gym_demo/pages/workout_screen.dart';
import 'package:gym_demo/providers/workout_set_list/workout_set_list.dart';
import 'package:isar/isar.dart';

void main() {
  late Isar isar;

  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open(
      [WorkoutSetSchema],
      directory: "/storage/emulated/0/Android/data/com.example.gym_demo/files",
    );
    // await isar.writeTxn(() async {
    //   isar.workoutSets.clear();
    // });
  });
  group("Workout Set page widget tests", () {
    // testWidgets('Test if list is blank', (WidgetTester tester) async {
    //   // Build our app and trigger a frame.
    //   await tester.pumpWidget(const ProviderScope(child: MyApp()));

    //   // Check if page loaded with blank list
    //   expect(find.text('Workout'), findsOneWidget);
    //   expect(find.text('Exercise'), findsNothing);
    //   expect(find.byIcon(Icons.add), findsOneWidget);
    // });

    // testWidgets('Test if Add Set screen open on tap Add Icon', (WidgetTester tester) async {
    //   // Build our app and trigger a frame.
    //   await tester.pumpWidget(const ProviderScope(child: MyApp()));

    //   await tester.tap(find.byType(Icon));
    //   await tester.pumpAndSettle();

    //   // The Add Set screen has been pushed
    //   expect(find.text('Add Set'), findsOneWidget);
    //   expect(find.text('Workout'), findsNothing);
    // });

    testWidgets('Add a new set', (WidgetTester tester) async {
      // late Isar isarInst;
      // WidgetsFlutterBinding.ensureInitialized();

      // await Isar.initializeIsarCore(download: true);
      // isarInst = await Isar.open(
      //   [WorkoutSetSchema],
      //   directory: "",
      // );

      // Build our app and trigger a frame.
      await tester.pumpWidget(ProviderScope(
        overrides: [
          // isarProvider.overrideWithValue(isar),
          workoutSetListProvider.overrideWith(() => WorkoutSetList()),
        ],
        child: const MyApp(),
      ));

      // final ref = ProviderScope.containerOf(tester.element(find.byType(WorkoutScreen)));
      // WorkoutSet set = WorkoutSet()
      //   ..dateTime = DateTime.now()
      //   ..exercise = "Bench Press"
      //   ..repetitions = 10
      //   ..weight = 20;
      // await ref.read(workoutSetListProvider.notifier).addSet(set, [], isarTest: isar);
      // await tester.pumpAndSettle(const Duration(seconds: 1));
      // ref.listen(workoutSetListProvider, (workoutsets, workoutsetList) {
      //   expect(workoutsetList.value!.length, 1);
      // });

      // The Add Set screen has been pushed
      expect(find.text('Bench Press'), findsNothing);
    });
  });
}

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});
