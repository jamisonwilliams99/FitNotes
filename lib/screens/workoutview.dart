/*
This screen will display all of the exercies in a workout
*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
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

class WorkoutView extends StatefulWidget {
  Workout workout;
  WorkoutView(this.workout);

  @override
  _WorkoutViewState createState() => _WorkoutViewState(workout);
}

class _WorkoutViewState extends State<WorkoutView> {
  Workout workout;
  DbHelper helper = DbHelper();
  List<Exercise> exercises;
  int count = 0;

  _WorkoutViewState(this.workout);

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = workout.title;

    if (exercises == null) {
      exercises = <Exercise>[];
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
                  onPressed: () {},
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
                      workout.id, "", 0, 0, exercises.length + 1));
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

  ReorderableListView workoutItems() {
    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          StandAloneExercise exercise = exercises.removeAt(oldIndex);
          exercises.insert(newIndex, exercise);
          updateExerciseOrder();
        });
      },
      padding: EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        StandAloneExercise currentExercise = this.exercises[position];
        child:
        return Card(
          key: ValueKey(currentExercise.id),
          color: myIndigo,
          elevation: 2.0,
          child: ListTile(
            title: Center(
              child: Text(
                currentExercise.name,
                style: whiteText,
              ),
            ),
            subtitle: Center(
              child: Text(
                  currentExercise.sets.toString() +
                      "x" +
                      currentExercise.reps.toString(),
                  style: whiteText),
            ),
            onTap: () {
              navigateToAddExercise(currentExercise);
            },
          ),
        );
      },
    );
  }

  Theme fixReorderableListViewAnimation() {
    return Theme(
        data: ThemeData(canvasColor: Colors.transparent),
        child: workoutItems());
  }

  void save() {
    helper.updateWorkout(workout);
    Navigator.pop(context, true);
  }

  void updateTitle() {
    workout.title = titleController.text;
    helper.updateWorkout(workout);
  }

  void updateExerciseOrder() {
    for (int i = 0; i < exercises.length; i++) {
      exercises[i].orderNum = i + 1;
      helper.updateStandAloneExercise(exercises[i]);
    }
  }

  void delete() async {
    int result;
    int deletedExercises;
    Navigator.pop(context, true);
    if (workout.id == null) {
      return;
    }
    result = await helper.deleteWorkout(workout.id);
    deletedExercises = await helper.deleteWorkoutExercises(workout.id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(content: Text("Workout deleted"));
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final exercisesFuture = helper.getStandAloneExercises(workout.id);
      exercisesFuture.then((result) {
        List<Exercise> exerciseList = <Exercise>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          StandAloneExercise currentExercise =
              StandAloneExercise.fromObject(result[i]);
          exerciseList.add(currentExercise);
        }
        exerciseList.sort((a, b) => a.orderNum.compareTo(b.orderNum));
        setState(() {
          count = count;
          exercises = exerciseList;
        });
      });
    });
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
                WorkoutExecution(workout, executedWorkout, exercises)));
  }
}
