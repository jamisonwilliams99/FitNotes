/*
This screen will be displayed when the user wants to add an exercise to 
a workout. They will be asked to enter the exercise name, sets, and reps
  - the exercise will then be displayed in a list view on the workoutview.dart
    page
*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/screens/customappbar.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracking_app/styles/styles.dart';

DbHelper helper = DbHelper();

class AddExercise extends StatefulWidget {
  final StandAloneExercise exercise;

  AddExercise(this.exercise);

  @override
  _AddExerciseState createState() => _AddExerciseState(exercise);
}

class _AddExerciseState extends State<AddExercise> {
  StandAloneExercise exercise;

  _AddExerciseState(this.exercise);

  TextEditingController nameController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = exercise.name;
    repsController.text = exercise.reps.toString();
    setsController.text = exercise.sets.toString();

    Padding deleteIcon = Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
          onTap: () {
            delete();
          },
          child: Icon(Icons.delete)),
    );

    return Scaffold(
      appBar: CustomAppBar.withIcons(exercise.name, [deleteIcon]),
      body: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 20.0),
          child: Center(
              child: TextField(
            controller: nameController,
            onChanged: (value) => this.updateName(),
            decoration: InputDecoration(
                labelText: "Exercise name",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
          )),
        ),
        Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
              child: TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                onChanged: (value) => this.updateReps(),
                decoration: InputDecoration(
                    labelText: "Reps",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
              child: TextField(
                controller: setsController,
                keyboardType: TextInputType.number,
                onChanged: (value) => this.updateSets(),
                decoration: InputDecoration(
                    labelText: "Sets",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
          ),
        ]),
        Center(
          child: ElevatedButton(
              onPressed: () {
                save();
              },
              child: Text("Save Exercise")),
        )
      ]),
    );
  }

  void delete() async {
    int result;
    Navigator.pop(context, true);
    if (exercise.id == null) {
      return;
    }
    result = await helper.deleteStandAloneExercise(exercise.id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(content: Text("Exercise deleted"));
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void save() {
    if (exercise.id != null) {
      helper.updateStandAloneExercise(exercise);
    } else {
      helper.insertStandAloneExercise(exercise);
    }
    Navigator.pop(context, true);
  }

  void updateName() {
    exercise.name = nameController.text;
  }

  void updateReps() {
    exercise.reps =
        repsController.text == "" ? 0 : int.parse(repsController.text);
  }

  void updateSets() {
    exercise.sets =
        setsController.text == "" ? 0 : int.parse(setsController.text);
  }
}
