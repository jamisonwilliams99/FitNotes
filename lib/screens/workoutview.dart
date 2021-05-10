/*
This screen will display all of the exercies in a workout
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';

class WorkoutView extends StatefulWidget {
  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  DbHelper helper = DbHelper();
  List<Exercise> exercises;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (exercises == null) {
      exercises = <Exercise>[];
      getData();
    }

    return Scaffold(
      body: workoutItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Exercise("", 0, 0));
        },
        tooltip: "Add new exercise",
        child: Icon(Icons.add),
      ),
    );
  }

  TextStyle textStyle = TextStyle(
    color: Colors.white,
  );

  ListView workoutItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        Exercise currentExercise = this.exercises[position];
        return Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
          child: Card(
            color: Colors.indigo,
            elevation: 2.0,
            child: ListTile(
              title: Center(
                child: Text(
                  currentExercise.name,
                  style: textStyle,
                ),
              ),
              subtitle: Center(
                child: Text(
                    currentExercise.sets.toString() +
                        "x" +
                        currentExercise.reps.toString(),
                    style: textStyle),
              ),
              onTap: () {
                navigateToDetail(currentExercise);
              },
            ),
          ),
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final exercisesFuture = helper.getExercises();
      exercisesFuture.then((result) {
        List<Exercise> exerciseList = <Exercise>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          exerciseList.add(Exercise.fromObject(result[i]));
        }
        setState(() {
          count = count;
          exercises = exerciseList;
        });
      });
    });
  }

  void navigateToDetail(Exercise exercise) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddExercise(exercise)));
    if (result == true) {
      getData();
    }
  }
}
