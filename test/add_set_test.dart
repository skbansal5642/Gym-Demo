import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gym_demo/main.dart';
import 'package:gym_demo/models/workout_set.dart';
import 'package:gym_demo/pages/add_set_screen.dart';
import 'package:gym_demo/providers/workout_set_list/workout_set_list.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/src/async_notifier.dart';

void main() {
  // setUpAll(() async {
  //   await Isar.initializeIsarCore(download: true);
  //   // final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
  //   isar = await Isar.open([WorkoutSetSchema], directory: '');
  // });

  // tearDownAll(() async {
  //   await isar.close();
  // });

  group("Add Set page widget tests", () {
    testWidgets('Change the exercise name', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.tap(find.byType(Icon));
      await tester.pumpAndSettle();

      // Find the DropdownButton widget
      final dropdownFinder = find.byType(DropdownButton<String>);
      expect(dropdownFinder, findsOneWidget);

      // Tap to open the dropdown menu
      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      // Find the DropdownMenuItem with the text 'Two'
      final itemFinder = find.text('Shoulder press').last;

      await tester.tap(itemFinder);
      await tester.pumpAndSettle();

      // Verify that the dropdown's value is now 'Two'
      expect(find.text('Shoulder press'), findsOneWidget);
    });

    testWidgets('Test if other fields loaded.', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.tap(find.byType(Icon).first);
      await tester.pumpAndSettle();

      // Find the text field of weight
      final weightFieldFinder = find.byKey(const Key("weight"));
      expect(weightFieldFinder, findsOneWidget);

      final repetitionsFieldFinder = find.byKey(const Key("repetitions"));
      expect(repetitionsFieldFinder, findsOneWidget);
    });

    testWidgets('Add a new set', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      late Isar isarInst;
      WidgetsFlutterBinding.ensureInitialized();
      isarInst = await Isar.open(
        [WorkoutSetSchema],
        directory: "/storage/emulated/0/Android/data/com.example.gym_demo/files",
      );
      await tester.pumpWidget(ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(isarInst),
          workoutSetListProvider.overrideWith(() => WorkoutSetList()),
        ],
        child: const MyApp(),
      ));
      await tester.tap(find.byType(Icon).first);
      await tester.pumpAndSettle();

      // Tap to open the dropdown menu
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Find the DropdownMenuItem with the text 'Two'
      final itemFinder = find.text('Shoulder press').last;

      await tester.tap(itemFinder);
      await tester.pumpAndSettle();

      // Enter weight
      await tester.enterText(find.byKey(const Key("weight")), '10.5');
      await tester.pumpAndSettle();
      // Enter repetiions
      await tester.enterText(find.byKey(const Key("repetitions")), '5');
      await tester.pumpAndSettle();

      final saveFinder = find.byType(OutlinedButton);
      expect(saveFinder, findsOneWidget);

      final ref = ProviderScope.containerOf(tester.element(find.byType(AddSet)));
      WorkoutSet set = WorkoutSet()
        ..dateTime = DateTime.now()
        ..exercise = "Bench Press"
        ..repetitions = 10
        ..weight = 20;
      await ref.read(workoutSetListProvider.notifier).addSet(set, []);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Find the Save button and add the set
      await tester.tap(saveFinder);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Check if there is any error
      // final snackbarFinder = find.text("Please fill the valid details");
      // expect(snackbarFinder, findsOneWidget);

      // Check if workout screen opened
      expect(find.text('Add Set'), findsNothing);
      expect(find.text('Workout'), findsOneWidget);
    });
  });
}

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError();
});
