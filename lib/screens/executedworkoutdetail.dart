/*
should display the workout name and all of the exercises along with the set info for the exercises

*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/screens/executedexercisedetail.dart';
import 'package:workout_tracking_app/screens/customappbar.dart';
import 'package:workout_tracking_app/styles/styles.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';

class ExecutedWorkoutDetail extends StatefulWidget {
  ExecutedWorkout executedWorkout;

  ExecutedWorkoutDetail(this.executedWorkout);

  @override
  _ExecutedWorkoutDetailState createState() =>
      _ExecutedWorkoutDetailState(executedWorkout);
}

class _ExecutedWorkoutDetailState extends State<ExecutedWorkoutDetail> {
  DbHelper helper = DbHelper();
  ExecutedWorkout executedWorkout;
  List<Exercise> exercises;
  int count = 0;

  _ExecutedWorkoutDetailState(this.executedWorkout);

  @override
  Widget build(BuildContext context) {
    if (exercises == null) {
      getData();
    }
    return Scaffold(
      appBar: CustomAppBar(executedWorkout.title),
      body: executedExerciseList(),
    );
  }

  // TODO: Implement
  ListView executedExerciseList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, position) {
        Exercise exercise = exercises[position];
        return Card(
            color: myIndigo,
            child: Column(
              children: [
                ListTile(
                  title: Text(exercise.name),
                  subtitle: Text("Tap to see exercise details"),
                  onTap: () {
                    navigateToExecutedExerciseDetail(position);
                  },
                )
              ],
            ));
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final exercisesFuture = helper.getExercises(executedWorkout.workoutId);
      exercisesFuture.then((result) {
        List<Exercise> exerciseList = <Exercise>[];
        count = result.length;
        for (int i = 0; i < result.length; i++) {
          Exercise exercise = Exercise.fromObject(result[i]);
          exercise.executedSets = getSets(exercise.id, executedWorkout.id);
          exerciseList.add(exercise);
        }
        setState(() {
          exercises = exerciseList;
          count = count;
        });
      });
    });
  }

  List<ExecutedSet> getSets(int exerciseId, int executedWorkoutId) {
    final setsFuture = helper.getExecutedSets(executedWorkoutId, exerciseId);
    List<ExecutedSet> setsList = <ExecutedSet>[];
    setsFuture.then((result) {
      for (int i = 0; i < result.length; i++) {
        setsList.add(ExecutedSet.fromObject(result[i]));
      }
    });
    return setsList;
  }

  void navigateToExecutedExerciseDetail(position) async {
    Exercise exercise = exercises[position];
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExecutedExerciseDetail(exercise)));
  }
}
