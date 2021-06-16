/*
This screen will display all of the exercies in a workout
*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/workoutitem.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/model/superset.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/screens/addsuperset.dart';
import 'package:workout_tracking_app/screens/workoutexecution.dart';
import 'package:workout_tracking_app/screens/customappbar.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:workout_tracking_app/styles/styles.dart';
import 'package:intl/intl.dart';

String getCurrentDate() {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

DbHelper helper = DbHelper();

class WorkoutView extends StatefulWidget {
  Workout workout;
  WorkoutView(this.workout);

  @override
  _WorkoutViewState createState() => _WorkoutViewState(workout);
}

class _WorkoutViewState extends State<WorkoutView> {
  Workout workout;
  List<WorkoutItem> workoutItems;
  Map<int, List> superSetExercises;
  int count = 0;

  _WorkoutViewState(this.workout);

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = workout.title;

    if (workoutItems == null) {
      workoutItems = <WorkoutItem>[];
      getData();
    }

    Padding deleteWorkoutIcon = Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
          onTap: () {
            delete();
          },
          child: Icon(Icons.delete)),
    );

    Padding startWorkoutIcon = Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
          onTap: () {
            String date = getCurrentDate();
            navigateToWorkoutExecution(
                ExecutedWorkout.withWorkoutId(workout.id, date, workout.title));
          },
          child: Icon(Icons.play_arrow)),
    );

    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar.withIcons(
            workout.title, [deleteWorkoutIcon, startWorkoutIcon]),
        body: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 30, 40, 10),
                child: TextField(
                  controller: titleController,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: "Workout Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ),
            Expanded(child: fixReorderableListViewAnimation()),
          ],
        ),
        floatingActionButton: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    navigateToAddSuperSet(SuperSet.withWorkoutId(
                        workout.id, workoutItems.length + 1));
                  },
                  backgroundColor: Colors.black,
                  label: Text("Add Superset"),
                  icon: Icon(Icons.add)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: FloatingActionButton.extended(
                heroTag: null,
                onPressed: () {
                  navigateToAddExercise(StandAloneExercise.withWorkoutId(
                      workout.id, "", 0, 0, workoutItems.length + 1));
                },
                tooltip: "Add new exercise",
                label: Text("Add Exercise"),
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        save();
      },
    );
  }

  void updateExerciseOrder(int oldIndex, int newIndex, bool movedForward) {
    workoutItems[newIndex].orderNum = newIndex + 1;
    if (movedForward) {
      for (int i = oldIndex; i < newIndex; i++) {
        workoutItems[i].orderNum--;
      }
    } else {
      for (int i = newIndex + 1; i <= oldIndex; i++) {
        workoutItems[i].orderNum++;
      }
    }
    for (int i = 0; i < workoutItems.length; i++) {
      if (workoutItems[i] is StandAloneExercise) {
        helper.updateStandAloneExercise(workoutItems[i]);
      } else {
        helper.updateSuperSet(workoutItems[i]);
      }
    }
  }

  ReorderableListView workoutItemList() {
    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        bool movedForward = false;
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
            movedForward = true;
          }

          WorkoutItem item = workoutItems.removeAt(oldIndex);
          workoutItems.insert(newIndex, item);
          updateExerciseOrder(oldIndex, newIndex, movedForward);
        });
      },
      padding: EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        print(workoutItems);
        WorkoutItem workoutItem = this.workoutItems[position];
        if (workoutItem is StandAloneExercise) {
          return exerciseCard(workoutItem);
        } else {
          return superSetCard(workoutItem);
        }
      },
    );
  }

  // find out how to display superset exercises in one card
  // most likely just place a column inside of card and set
  // children to widgets containing info for each exercise
  Card superSetCard(SuperSet superSet) {
    List<SuperSetExercise> exercises = this.superSetExercises[superSet.id];
    return Card(
      key: ValueKey(superSet.id),
      child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            SuperSetExercise exercise = exercises[index];
            return ListTile(
                title: Center(child: Text(exercise.name)),
                subtitle: Center(
                  child: Text(
                      exercise.sets.toString() + "x" + exercise.reps.toString(),
                      style: whiteText),
                ));
          }),
    );
  }

  Card exerciseCard(StandAloneExercise exercise) {
    return Card(
      key: ValueKey(exercise.id),
      color: myIndigo,
      elevation: 2.0,
      child: ListTile(
        title: Center(
          child: Text(
            exercise.name,
            style: whiteText,
          ),
        ),
        subtitle: Center(
          child: Text(exercise.sets.toString() + "x" + exercise.reps.toString(),
              style: whiteText),
        ),
        onTap: () {
          navigateToAddExercise(exercise);
        },
      ),
    );
  }

  Theme fixReorderableListViewAnimation() {
    return Theme(
        data: ThemeData(canvasColor: Colors.transparent),
        child: workoutItemList());
  }

  void save() {
    helper.updateWorkout(workout);
    Navigator.pop(context, true);
  }

  void updateTitle() {
    workout.title = titleController.text;
    helper.updateWorkout(workout);
  }

  void delete() async {
    int result;
    int deletedExercises;
    int deletedSupersets;
    Navigator.pop(context, true);
    if (workout.id == null) {
      return;
    }
    result = await helper.deleteWorkout(workout.id);
    deletedExercises = await helper.deleteWorkoutExercises(workout.id);
    deletedSupersets = await helper.deleteWorkoutSuperSets(
        workout.id); // should also delete all of the superset exercises
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(content: Text("Workout deleted"));
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  Future<void> getData() async {
    final db = await helper.initializeDb();
    final exercisesData = await helper.getStandAloneExercises(workout.id);

    List<WorkoutItem> itemsList = <WorkoutItem>[];
    final Map<int, List> superSetMap = Map();

    try {
      count = exercisesData.length;
      for (int i = 0; i < exercisesData.length; i++) {
        StandAloneExercise exercise =
            StandAloneExercise.fromObject(exercisesData[i]);
        itemsList.add(exercise);
      }

      final superSetsData = await helper.getSuperSets(workout.id);

      count += superSetsData.length;
      await Future.forEach(superSetsData, (data) async {
        SuperSet superSet = SuperSet.fromObject(data);
        List<SuperSetExercise> tempExercises = <SuperSetExercise>[];
        itemsList.add(superSet);
        var superSetExercisesData =
            await helper.getSuperSetExercises(superSet.id);

        for (int j = 0; j < superSetExercisesData.length; j++) {
          tempExercises
              .add(SuperSetExercise.fromObject(superSetExercisesData[j]));
        }
        superSetMap[superSet.id] = tempExercises;
      });
    } finally {
      itemsList.sort((a, b) => a.orderNum.compareTo(b.orderNum));
      setState(() {
        workoutItems = itemsList;
        superSetExercises = superSetMap;
        count = count;
      });
    }
  }

  Future<List> getSuperSetExerciseData() async {}

  // split this into different functions
  // async calls will likely cause problems
  // void getData() {
  //   final dbFuture = helper.initializeDb();
  //   final List<WorkoutItem> itemsList = <WorkoutItem>[];
  //   final List<int> superSetIds = <int>[];
  //   final Map<int, List> superSetMap = Map();

  //   dbFuture.then((result) {
  //     final exercisesFuture = helper.getStandAloneExercises(workout.id);
  //     exercisesFuture.then((result) {
  //       count = result.length;
  //       for (int i = 0; i < result.length; i++) {
  //         StandAloneExercise currentExercise =
  //             StandAloneExercise.fromObject(result[i]);
  //         itemsList.add(currentExercise);
  //       }

  //       final superSetsFuture = helper.getSuperSets(workout.id);
  //       superSetsFuture.then((result) {
  //         count += result.length;
  //         for (int i = 0; i < result.length; i++) {
  //           SuperSet currentSuperSet = SuperSet.fromObject(result[i]);
  //           superSetIds.add(currentSuperSet.id);
  //           itemsList.add(currentSuperSet);
  //         }
  //         for (int i = 0; i < superSetIds.length; i++) {
  //           int id = superSetIds[i];
  //           final superSetExercisesFuture = helper.getSuperSetExercises(id);
  //           superSetExercisesFuture.then((result) {
  //             List<SuperSetExercise> exerciseList = <SuperSetExercise>[];
  //             // for (int j = 0; j < result.length; j++) {
  //             //   exerciseList.add(SuperSetExercise.fromObject(result[j]));
  //             // }
  //             Future.forEach(result, (element) async {
  //               exerciseList.add(SuperSetExercise.fromObject(element));
  //             });
  //             superSetMap[id] = exerciseList;
  //           });
  //         }

  //         // Try using future.forEach
  //       });
  //     });
  //     itemsList.sort((a, b) => a.orderNum.compareTo(b.orderNum));
  //     setState(() {
  //       this.count = count;
  //       this.workoutItems = itemsList;
  //       this.superSetExercises = superSetMap;
  //     });
  //   });
  // }

  void navigateToAddSuperSet(SuperSet superSet) async {
    if (superSet.id == null) {
      superSet.id = await helper.insertSuperSet(superSet);
    }

    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddSuperSet(superSet)));
    if (result == true) {
      getData();
    }
    print(superSetExercises.length);
  }

  void navigateToAddExercise(Exercise exercise) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddExercise(exercise)));
    if (result == true) {
      getData();
    }
  }

  void navigateToWorkoutExecution(ExecutedWorkout executedWorkout) async {
    executedWorkout.id = await helper.insertExecutedWorkout(executedWorkout);
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                WorkoutExecution(workout, executedWorkout, workoutItems)));
  }
}
