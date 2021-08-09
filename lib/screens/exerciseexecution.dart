/*
This Widget will display the execution page for every exercise in the exercise list
in WorkoutExecution
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/util/noanimationpageroute.dart';
import 'package:workout_tracking_app/styles/styles.dart';

class ExerciseExecution extends StatefulWidget {
  StandAloneExercise exercise;
  ExecutedWorkout executedWorkout;
  int numCompletedSets;
  int position;
  bool clickedCard;
  int counter;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;

  ExerciseExecution(this.exercise, this.executedWorkout, this.numCompletedSets,
      this.position, this.anotherExercise, this.navigate, this.completeSet);

  @override
  _ExerciseExecutionState createState() => _ExerciseExecutionState(
      exercise,
      executedWorkout,
      numCompletedSets,
      position,
      anotherExercise,
      navigate,
      completeSet);
}

class _ExerciseExecutionState extends State<ExerciseExecution> {
  StandAloneExercise exercise;
  ExecutedWorkout executedWorkout;
  int numCompletedSets;
  int position;
  bool clickedCard;
  int counter;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;

  List<ExecutedStandAloneExerciseSet> executedSets;
  int count = 0;
  String repsErrorText;
  String weightErrorText;
  bool validReps = false;
  bool validWeight = false;

  _ExerciseExecutionState(
      this.exercise,
      this.executedWorkout,
      this.numCompletedSets,
      this.position,
      this.anotherExercise,
      this.navigate,
      this.completeSet);

  TextEditingController repsController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (executedSets == null) {
      executedSets = <ExecutedStandAloneExerciseSet>[];
      getData();
    }
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
                  } else {
                    navigateToWorkoutExecution(context);
                  }
                },
                child: Icon(
                  Icons.arrow_forward,
                  //10color: anotherExercise ? Colors.white : Colors.transparent,
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
                    keyboardType: TextInputType.number,
                    onChanged: (value) => validateRepsInput(),
                    decoration: InputDecoration(
                        labelText: "Reps",
                        errorText: repsErrorText,
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
                    keyboardType: TextInputType.number,
                    onChanged: (value) => validateWeightInput(),
                    decoration: InputDecoration(
                        labelText: "Weight",
                        errorText: weightErrorText,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                if (isValidSet())
                  completeSetWrapper();
                else {
                  AlertDialog alertDialog =
                      AlertDialog(content: Text("Not a valid set"));
                  showDialog(context: context, builder: (_) => alertDialog);
                }
              },
              child: Text("Complete Set")),
          Text(numCompletedSets.toString() + "/" + exercise.sets.toString()),
          Expanded(child: setList()),
        ],
      ),
    );
  }

  ListView setList() {
    return ListView.builder(
      itemCount: executedSets.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: myIndigo, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            title: Text("Set " + (position + 1).toString()),
            subtitle: Text("Reps: " +
                executedSets[position].reps.toString() +
                "   Weight: " +
                executedSets[position].weight.toString() +
                " lbs"),
          ),
        );
      },
    );
  }

  // don't like this, please change
  bool isValidSet() {
    return validReps &&
        validWeight &&
        weightController.text.isNotEmpty &&
        repsController.text.isNotEmpty;
  }

  void validateRepsInput() {
    String input = repsController.text;
    if (input.contains('.')) {
      setState(() {
        repsErrorText = "Number of reps cannots be a decimal value";
        validReps = false;
      });
    } else {
      setState(() {
        repsErrorText = null;
        validReps = true;
      });
    }
  }

  void validateWeightInput() {
    String input = weightController.text;
    int numPeriods = '.'.allMatches(input).length;
    if (numPeriods > 1) {
      setState(() {
        weightErrorText = "Invalid input";
        validWeight = false;
      });
    } else {
      setState(() {
        weightErrorText = null;
        validWeight = true;
      });
    }
  }

  void completeSetWrapper() {
    double weight = double.parse(weightController.text);
    int reps = int.parse(repsController.text);
    ExecutedStandAloneExerciseSet executedSet =
        ExecutedStandAloneExerciseSet.withExternalId(
            executedWorkout.id, exercise.id, exercise.name, weight, reps);
    helper.insertExecutedSet(executedSet);
    setState(() {
      numCompletedSets = completeSet(position);
    });
    getData();
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final executedSetsFuture =
          helper.getExecutedSets(executedWorkout.id, exercise.id);
      executedSetsFuture.then((result) {
        List<ExecutedStandAloneExerciseSet> setList =
            <ExecutedStandAloneExerciseSet>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          ExecutedStandAloneExerciseSet executedSet =
              ExecutedStandAloneExerciseSet.fromObject(result[i]);
          setList.add(executedSet);
        }
        setState(() {
          count = count;
          executedSets = setList;
        });
      });
    });
  }

  void navigateToNextExercise() {
    navigate(position + 1);
  }

  void navigateToWorkoutExecution(BuildContext context) {
    for (int i = position; i >= 0; i--) {
      Navigator.pop(context);
    }
  }
}
