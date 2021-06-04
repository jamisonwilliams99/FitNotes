/*
This Widget will display the base page when a user begins an exercise
- it will need to receive the list of exercises from WorkoutView
*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/screens/exerciseexecution.dart';
import 'package:workout_tracking_app/styles/styles.dart';
import 'package:workout_tracking_app/util/noanimationpageroute.dart';

class WorkoutExecution extends StatefulWidget {
  Workout workout;
  ExecutedWorkout executedWorkout;
  List<Exercise> exercises;
  WorkoutExecution(this.workout, this.executedWorkout, this.exercises);

  @override
  _WorkoutExecutionState createState() =>
      _WorkoutExecutionState(workout, executedWorkout, exercises);
}

class _WorkoutExecutionState extends State<WorkoutExecution> {
  Workout workout;
  ExecutedWorkout executedWorkout;
  List<Exercise> exercises;
  List<List<bool>> exerciseSetStates = [];
  List<int> completedSets;

  _WorkoutExecutionState(workout, executedWorkout, exercises) {
    this.workout = workout;
    this.executedWorkout = executedWorkout;
    this.exercises = exercises;
    completedSets = List.generate(exercises.length, (index) => 0);
    populateStates();
  }

  void populateStates() {
    for (int i = 0; i < exercises.length; i++) {
      Exercise exercise = exercises[i];
      this
          .exerciseSetStates
          .add(List.generate(exercise.sets, (index) => false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(workout.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      navigateToExerciseExecution(0);
                    },
                    child: Text("Start from beginning")),
              ),
            ),
            Expanded(child: exerciseCards()),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 250,
                    child: ElevatedButton(
                        onPressed: () {}, child: Text("Complete Workout")),
                  )),
            ),
          ],
        ));
  }

  int completeSet(position) {
    setState(() {
      this.completedSets[position]++;
    });
    for (int i = 0; i < this.exerciseSetStates[position].length; i++) {
      if (!this.exerciseSetStates[position][i]) {
        setState(() {
          this.exerciseSetStates[position][i] = true;
        });
        break;
      }
    }
    return completedSets[position];
  }

  ListView exerciseCards() {
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (BuildContext context, int position) {
        Exercise currentExercise = this.exercises[position];
        return Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
          child: ExerciseCard(currentExercise, position,
              exerciseSetStates[position], navigateToExerciseExecution),
        );
      },
    );
  }

  bool isAnotherExercise(int position) {
    if (position + 1 < exercises.length)
      return true;
    else
      return false;
  }

  void navigateToExerciseExecution(int position,
      [bool clickedCard = false]) async {
    bool anotherExercise;
    if (!clickedCard) {
      anotherExercise = isAnotherExercise(position);
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExerciseExecution(
                  exercises[position],
                  executedWorkout,
                  completedSets[position],
                  position,
                  anotherExercise,
                  navigateToExerciseExecution,
                  completeSet)));
    } else {
      for (int i = 0; i <= position; i++) {
        ExerciseExecution exerciseExecution = ExerciseExecution(
            exercises[i],
            executedWorkout,
            completedSets[i],
            i,
            isAnotherExercise(i),
            navigateToExerciseExecution,
            completeSet);
        pushWithoutAnimation(exerciseExecution);
      }
    }
  }

  Future<T> pushWithoutAnimation<T extends Object>(Widget page) {
    Route route = NoAnimationPageRoute(builder: (BuildContext context) => page);
    return Navigator.push(context, route);
  }
}

class ExerciseCard extends StatefulWidget {
  Exercise exercise;
  int position; // index of exercise in exercises list
  List<bool> blockStates;
  Function(int, [bool])
      navigate; // callback funciton for navigating to the exercise execuiton screen
  ExerciseCard(this.exercise, this.position, this.blockStates, this.navigate,
      {Key key})
      : super(key: key);

  @override
  _ExerciseCardState createState() =>
      _ExerciseCardState(exercise, position, blockStates, navigate);
}

class _ExerciseCardState extends State<ExerciseCard> {
  Exercise exercise;
  int position;
  List<bool> blockStates;
  Function(int, [bool]) navigate;
  List<Widget> blocks = [];
  _ExerciseCardState(
      this.exercise, this.position, this.blockStates, this.navigate);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        color: myIndigo,
        elevation: 2.0,
        child: ListTile(
          title: Center(
              child: Text(
            exercise.name,
            style: whiteText,
          )),
          onTap: () {
            navigate(position, true);
          },
        ),
      ),
      drawProgressBlocks(exercise.sets)
    ]);
  }

  Widget drawProgressBlocks(int numSets) {
    List<Widget> blockList = [];
    for (int i = 0; i < numSets; i++) {
      Widget block = progressBlock(i);
      blockList.add(block);
    }
    setState(() {
      blocks = blockList;
    });
    return Row(children: blocks);
  }

  Widget progressBlock(int stateIndex) {
    return Padding(
        padding: EdgeInsets.all(6.0),
        child: Container(
            height: 10.0,
            width: 20.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: setFill(stateIndex),
                border: Border.all(color: myIndigo, width: 2))));
  }

  Color setFill(int stateIndex) {
    if (!blockStates[stateIndex]) {
      return Colors.transparent;
    } else {
      return myIndigo;
    }
  }
}
