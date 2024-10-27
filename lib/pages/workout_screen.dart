import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_demo/models/workout_set.dart';
import 'package:gym_demo/providers/workout_set_list/workout_set_list.dart';

class WorkoutScreen extends ConsumerStatefulWidget {
  const WorkoutScreen({super.key});

  @override
  ConsumerState<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends ConsumerState<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final setAsyncValue = ref.watch(workoutSetListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: setAsyncValue.when(
        data: (sets) => ListView.builder(
          itemCount: sets.length,
          itemBuilder: (context, index) {
            WorkoutSet workoutSet = sets[index];
            return GestureDetector(
              onTap: () {
                showAddSetDialog(sets, index: index);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Dismissible(
                  key: Key('${workoutSet.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) {
                    ref.read(workoutSetListProvider.notifier).deleteSet(index, setAsyncValue.value ?? []);
                  },
                  child: ListTile(
                    title: Text('Exercise: ${workoutSet.exercise}'),
                    subtitle: Text(' Weight: ${workoutSet.weight}kg \n Repetitions: ${workoutSet.repetitions}'),
                    trailing: Text(
                      '${workoutSet.dateTime.day.toString().padLeft(2, "0")}-${workoutSet.dateTime.month.toString().padLeft(2, "0")}-${workoutSet.dateTime.month.toString().padLeft(2, "0")}',
                      style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddSetDialog(setAsyncValue.value ?? []),
        child: const Icon(Icons.add),
      ),
    );
  }

  void showAddSetDialog(List<WorkoutSet> workoutSetList, {int? index}) {
    Map<String, dynamic> params = {
      "workoutId": 0,
      "workoutSetList": workoutSetList,
    };
    if (index != null) {
      params["index"] = index;
    }
    context.pushNamed(
      '/add_set',
      extra: params,
    );
  }
}
