import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_demo/main.dart';
import 'package:gym_demo/models/workout_set.dart';
import 'package:gym_demo/providers/workout_set_list/workout_set_list.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';

// void main() {
//   late Isar isar;
//   setUpAll(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Isar.initializeIsarCore(download: true);
//     // final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
//     isar = await Isar.open([WorkoutSetSchema], directory: '');
//   });

//   tearDownAll(() async {
//     await isar.close();
//   });

//   // test('WorkoutSetList Provider Tests', () async {
//   //   final container = ProviderContainer();
//   //   final workoutSetListResult = container.read(workoutSetListProvider);
//   //   // ... your test cases

//   //   final mockIsar = MockIsar();
//   //   when(mockIsar.workoutSets).thenReturn(MockWorkoutSetCollection());

//   //   final mockWorkoutSetCollection = MockWorkoutSetCollection();
//   //   final workoutSets = [
//   //     WorkoutSet(id: 1, exercise: 'Bench Press', repetitions: 10, weight: 100),
//   //     WorkoutSet(id: 2, exercise: 'Squats', repetitions: 12, weight: 130),
//   //   ];
//   //   when(mockWorkoutSetCollection.where()).thenReturn(mockWorkoutSetCollection);
//   //   when(mockWorkoutSetCollection.findAll()).thenAnswer((_) async => workoutSets);
//   // });
// }

abstract interface class IsarAdapter {
  Future<T?> get<T>(Id id);

  Future<void> save<T>(T item);
}

class IsarAdapterImpl implements IsarAdapter {
  IsarAdapterImpl._privateConstructor();

  static final IsarAdapterImpl _instance = IsarAdapterImpl._privateConstructor();

  static IsarAdapterImpl get instance => _instance;

  late final Isar isarInstance;

  Future<void> init() async {
    final directory = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    isarInstance = await Isar.open(
      [WorkoutSetSchema],
      directory: directory!.path,
    );
  }

  @override
  Future<void> save<T>(T item) async {
    await isarInstance.collection<T>().put(item);
  }

  @override
  Future<T?> get<T>(Id id) async {
    return await isarInstance.collection<T>().get(id);
  }
}

class MockIsarAdapter implements IsarAdapter {
  @override
  Future<T?> get<T>(Id id) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> save<T>(T item) {
    // TODO: implement save
    throw UnimplementedError();
  }
}

class FakeWorkoutSetIsar extends Fake implements WorkoutSet {}

void main() {
  late MockIsarAdapter mockIsarAdapter;
  // late Work   MonthlySummaryLocalDataSource dataSource;

  setUp(() {
    mockIsarAdapter = MockIsarAdapter();
    // dataSource = MonthlySummaryIsarLocalDataSourceImpl(isarAdapter: mockIsarAdapter);

    // registerFallbackValue(FakeWorkoutSetIsar);
  });

  const tUserId = 'userId';

  // final tMonthlySummary = WorkoutSet(

  // );

  final tMonthlySummaryIsar = WorkoutSet()
    ..dateTime = DateTime.now()
    ..exercise = "Bench Press"
    ..weight = 10.5
    ..repetitions = 5;

  test('should return MonthlySummary when isarAdapter.get returns a non null MonthlySummaryIsar', () async {
    //arrange
    // when(() => mockIsarAdapter.get<MonthlySummaryIsar>(any()))
    //     .thenAnswer((_) async => tMonthlySummaryIsar);

    // //act
    // final result = await dataSource.getMonthlySummary(
    //   userId: tUserId,
    //   month: tMonthlySummary.yearMonth.month,
    //   year: tMonthlySummary.yearMonth.year,
    // );

    // //assert
    // expect(result, tMonthlySummary);

    // verify(() => mockIsarAdapter.get<MonthlySummaryIsar>(tMonthlySummaryIsar.id))).called(1);
    // verifyNoMoreInteractions(mockIsarAdapter);
  });
}
