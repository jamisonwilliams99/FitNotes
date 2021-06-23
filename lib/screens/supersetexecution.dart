import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/superset.dart';
import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/util/noanimationpageroute.dart';
import 'package:workout_tracking_app/styles/styles.dart';

class SuperSetExecution extends StatefulWidget {
  SuperSet superSet;
  ExecutedWorkout executedWorkout;
  int numCompletedSets;
  int position;
  bool clickedCard;
  int counter;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;

  SuperSetExecution(this.superSet, this.executedWorkout, this.numCompletedSets,
      this.position, this.anotherExercise, this.navigate, this.completeSet);

  @override
  _SuperSetExecutionState createState() => _SuperSetExecutionState(
      superSet,
      executedWorkout,
      numCompletedSets,
      position,
      anotherExercise,
      navigate,
      completeSet);
}

class _SuperSetExecutionState extends State<SuperSetExecution> {
  SuperSet superSet;
  ExecutedWorkout executedWorkout;
  int numCompletedSets;
  int position;
  bool clickedCard;
  int counter;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;

  List<SuperSetExercise> exercises;
  List<ExecutedSet> executedSets;
  int count = 0;
  int indexOfCurrentExercise = 0;
  String repsErrorText;
  String weightErrorText;
  bool validReps = false;
  bool validWeight = false;

  _SuperSetExecutionState(
      this.superSet,
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
    if (exercises == null) {
      exercises = <SuperSetExercise>[];
      getData();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Super Set"),
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
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            // need some sort of method here for dynamically displaying exercises
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: generateExerciseWidgets(),
              ),
            ),
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
                  if (indexOfCurrentExercise < exercises.length - 1) {
                    setState(() {
                      indexOfCurrentExercise++;
                    });
                  } else {
                    setState(() {
                      indexOfCurrentExercise = 0;
                    });
                  }
                },
                child: Text("Complete Set")),
          ],
        ));
  }

  List<Widget> generateExerciseWidgets() {
    TextStyle textStyle;
    Color exerciseColor;

    TextStyle currentExerciseTextStyle =
        TextStyle(color: Colors.white, fontSize: 15);

    TextStyle otherExerciseTextStyle =
        TextStyle(color: Colors.grey[800], fontSize: 15);

    return List.generate(exercises.length, (index) {
      if (index == indexOfCurrentExercise) {
        textStyle = currentExerciseTextStyle;
        exerciseColor = myIndigo;
      } else {
        textStyle = otherExerciseTextStyle;
        exerciseColor = Colors.transparent;
      }
      return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: exerciseColor, borderRadius: BorderRadius.circular(10)),
            child: Text(exercises[index].name, style: textStyle)),
      );
    });
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

  // Todo: implement
  void getData() async {
    final db = await helper.initializeDb();
    final exercisesData = await helper.getSuperSetExercises(superSet.id);

    List<SuperSetExercise> exerciseList = <SuperSetExercise>[];

    for (int i = 0; i < exercisesData.length; i++) {
      SuperSetExercise exercise = SuperSetExercise.fromObject(exercisesData[i]);
      exerciseList.add(exercise);
    }

    setState(() {
      exercises = exerciseList;
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
