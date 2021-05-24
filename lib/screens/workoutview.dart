/*
This screen will display all of the exercies in a workout
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/screens/workoutexecution.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:workout_tracking_app/styles/styles.dart';

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

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(workout.title),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    delete();
                  },
                  child: Icon(Icons.delete)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    navigateToWorkoutExecution();
                  },
                  child: Icon(Icons.play_arrow)),
            ),
          ],
        ),
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
                          borderRadius: BorderRadius.circular(
                              5.0))), // need to define the titleUpdate function
                ),
              ),
            ),
            Expanded(child: workoutItems()),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToAddExercise(Exercise.withWorkoutId(workout.id, "", 0, 0));
          },
          tooltip: "Add new exercise",
          label: Text("Add New Exercise"),
          icon: Icon(Icons.add),
        ),
      ),
      onWillPop: () {
        save();
      },
    );
  }

  ListView workoutItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        Exercise currentExercise = this.exercises[position];
        return Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
          child: Card(
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
          ),
        );
      },
    );
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
      final exercisesFuture =
          helper.getExercises(workout.id); // need to pass workoutId here
      exercisesFuture.then((result) {
        List<Exercise> exerciseList = <Exercise>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          Exercise currentExercise = Exercise.fromObject(result[i]);
          exerciseList.add(currentExercise);
        }
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

  void navigateToWorkoutExecution() async {
    bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WorkoutExecution(workout, exercises)));
  }
}
