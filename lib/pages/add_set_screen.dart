import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_demo/models/workout_set.dart';
import 'package:gym_demo/providers/workout_set_list/workout_set_list.dart';
import 'package:gym_demo/utils/constants.dart';

class AddSet extends ConsumerStatefulWidget {
  const AddSet({
    super.key,
    required this.workoutSetList,
    this.index,
  });
  final int? index;
  final List<dynamic> workoutSetList;

  @override
  ConsumerState<AddSet> createState() => _DialogAddSetState();
}

class _DialogAddSetState extends ConsumerState<AddSet> {
  final exerciseProvider = StateProvider<String>((ref) => kExercises.first);

  final TextEditingController weightController = TextEditingController();

  final TextEditingController repetitionController = TextEditingController();

  List<WorkoutSet> workoutSetList = [];

  @override
  void initState() {
    for (var workoutSet in widget.workoutSetList) {
      workoutSetList.add(workoutSet as WorkoutSet);
    }
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        ref.read(exerciseProvider.notifier).state = workoutSetList[widget.index!].exercise;
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (widget.index != null) {
      weightController.text = workoutSetList[widget.index!].weight.toString();
      repetitionController.text = workoutSetList[widget.index!].repetitions.toString();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final selectedExercise = ref.watch(exerciseProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Set')),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Exercise"),
              ),
              DropdownButton<String>(
                elevation: 20,
                padding: const EdgeInsets.all(10),
                isDense: true,
                isExpanded: true,
                value: selectedExercise,
                items: kExercises.map((exercise) {
                  return DropdownMenuItem(
                    value: exercise,
                    child: Text(exercise),
                  );
                }).toList(),
                onChanged: (value) {
                  ref.read(exerciseProvider.notifier).state = value ?? '';
                },
              ),
              TextFormField(
                key: const Key("weight"),
                controller: weightController,
                decoration: const InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
              ),
              TextFormField(
                key: const Key("repetitions"),
                controller: repetitionController,
                decoration: const InputDecoration(labelText: 'Repetitions'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(onPressed: context.pop, child: const Text("close")),
                  FilledButton(
                      onPressed: () async {
                        try {
                          if (widget.index == null) {
                            await addSet(selectedExercise);
                          } else {
                            await updateSet(selectedExercise, widget.index!, workoutSetList[widget.index!].id);
                          }
                          context.pop();
                        } catch (e) {
                          String errorText = 'Please fill the valid details';
                          if (weightController.text.trim().isEmpty) {
                            errorText = "Weight can not be empty";
                          } else if (repetitionController.text.trim().isEmpty) {
                            errorText = "Repetitions can not be empty";
                          }
                          final snackBar = SnackBar(content: Text(errorText));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: const Text("Save")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addSet(String exercise) async {
    WorkoutSet set = WorkoutSet()
      ..dateTime = DateTime.now()
      ..exercise = exercise
      ..repetitions = int.parse(repetitionController.text)
      ..weight = double.parse(weightController.text);
    await ref.read(workoutSetListProvider.notifier).addSet(set, workoutSetList);
    const snackBar = SnackBar(content: Text('Set added successfully.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> updateSet(String exercise, int index, int id) async {
    await ref.read(workoutSetListProvider.notifier).updateSet(
          id,
          index,
          workoutSetList,
          exercise: exercise,
          repetitions: int.parse(repetitionController.text),
          weight: double.parse(weightController.text),
        );
    const snackBar = SnackBar(content: Text('Set updated successfully.'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
