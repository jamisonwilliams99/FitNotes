import 'package:flutter/material.dart';
import 'package:workout_tracking_app/screens/customappbar.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/styles/styles.dart';

class ExecutedExerciseDetail extends StatefulWidget {
  Exercise exercise;

  ExecutedExerciseDetail(this.exercise);

  @override
  _ExecutedExerciseDetailState createState() =>
      _ExecutedExerciseDetailState(exercise);
}

class _ExecutedExerciseDetailState extends State<ExecutedExerciseDetail> {
  Exercise exercise;

  _ExecutedExerciseDetailState(this.exercise);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(exercise.name),
      body: setList(),
    );
  }

  ListView setList() {
    return ListView.builder(
      itemCount: exercise.executedSets.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: myIndigo, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text("Set " + (position + 1).toString()),
            subtitle: Text("Reps: " +
                exercise.executedSets[position].reps.toString() +
                "   Weight: " +
                exercise.executedSets[position].weight.toString() +
                " lbs"),
          ),
        );
      },
    );
  }
}
