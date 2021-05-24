/*
This Widget will display the execution page for every exercise in the exercise list
in WorkoutExecution
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:workout_tracking_app/styles/styles.dart';

class ExerciseExecution extends StatefulWidget {
  Exercise exercise;
  int numCompletedSets;
  int position;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;
  ExerciseExecution(this.exercise, this.numCompletedSets, this.position,
      this.anotherExercise, this.navigate, this.completeSet);

  @override
  _ExerciseExecutionState createState() => _ExerciseExecutionState(exercise,
      numCompletedSets, position, anotherExercise, navigate, completeSet);
}

class _ExerciseExecutionState extends State<ExerciseExecution> {
  Exercise exercise;
  int numCompletedSets;
  int position;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;
  _ExerciseExecutionState(this.exercise, this.numCompletedSets, this.position,
      this.anotherExercise, this.navigate, this.completeSet);

  TextEditingController repsController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
                onTap: () {
                  if (anotherExercise) {
                    navigateToNextExercise();
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: anotherExercise ? Colors.white : Colors.transparent,
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: repsController,
                    decoration: InputDecoration(
                        labelText: "Reps",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: weightController,
                    decoration: InputDecoration(
                        labelText: "Weight",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                completeSetWrapper();
              },
              child: Text("Complete Set")),
          Text(numCompletedSets.toString() + "/" + exercise.sets.toString()),
          Expanded(child: setList()),
        ],
      ),
    );
  }

  void completeSetWrapper() {
    setState(() {
      numCompletedSets = completeSet(position);
    });
  }

  ListView setList() {
    return ListView.builder(
      itemCount: numCompletedSets,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: myIndigo, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text("Set " + (position + 1).toString()),
            subtitle: Text("Reps: " +
                repsController.text +
                "   Weight: " +
                weightController.text),
          ),
        );
      },
    );
  }

  void navigateToNextExercise() {
    navigate(position + 1);
  }
}
