/*
This Widget will display the base page when a user begins an WorkoutItem
- it will need to receive the list of workoutItems from WorkoutView
*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/workoutitem.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/screens/exerciseexecution.dart';
import 'package:workout_tracking_app/styles/styles.dart';
import 'package:workout_tracking_app/util/noanimationpageroute.dart';

class WorkoutExecution extends StatefulWidget {
  Workout workout;
  ExecutedWorkout executedWorkout;
  List<WorkoutItem> workoutItems;
  WorkoutExecution(this.workout, this.executedWorkout, this.workoutItems);

  @override
  _WorkoutExecutionState createState() =>
      _WorkoutExecutionState(workout, executedWorkout, workoutItems);
}

class _WorkoutExecutionState extends State<WorkoutExecution> {
  Workout workout;
  ExecutedWorkout executedWorkout;
  List<WorkoutItem> workoutItems;
  List<List<bool>> workoutItemsetStates = [];
  List<int> completedSets;

  _WorkoutExecutionState(workout, executedWorkout, workoutItems) {
    this.workout = workout;
    this.executedWorkout = executedWorkout;
    this.workoutItems = workoutItems;
    completedSets = List.generate(workoutItems.length, (index) => 0);
    populateStates();
  }

  void populateStates() {
    for (int i = 0; i < workoutItems.length; i++) {
      WorkoutItem workoutItem = workoutItems[i];
      this
          .workoutItemsetStates
          .add(List.generate(WorkoutItem.sets, (index) => false));
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
                      navigateToWorkoutItemExecution(0);
                    },
                    child: Text("Start from beginning")),
              ),
            ),
            Expanded(child: WorkoutItemCards()),
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
    for (int i = 0; i < this.workoutItemsetStates[position].length; i++) {
      if (!this.workoutItemsetStates[position][i]) {
        setState(() {
          this.workoutItemsetStates[position][i] = true;
        });
        break;
      }
    }
    return completedSets[position];
  }

  ListView WorkoutItemCards() {
    return ListView.builder(
      itemCount: workoutItems.length,
      itemBuilder: (BuildContext context, int position) {
        WorkoutItem currentWorkoutItem = this.workoutItems[position];
        return Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
          child: WorkoutItemCard(currentWorkoutItem, position,
              workoutItemsetStates[position], navigateToWorkoutItemExecution),
        );
      },
    );
  }

  bool isAnotherWorkoutItem(int position) {
    if (position + 1 < workoutItems.length)
      return true;
    else
      return false;
  }

  void navigateToWorkoutItemExecution(int position,
      [bool clickedCard = false]) async {
    bool anotherWorkoutItem;
    if (!clickedCard) {
      anotherWorkoutItem = isAnotherWorkoutItem(position);
      bool result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ExerciseExecution(
                  workoutItems[position],
                  executedWorkout,
                  completedSets[position],
                  position,
                  anotherWorkoutItem,
                  navigateToWorkoutItemExecution,
                  completeSet)));
    } else {
      for (int i = 0; i <= position; i++) {
        ExerciseExecution exerciseExecution = ExerciseExecution(
            workoutItems[i],
            executedWorkout,
            completedSets[i],
            i,
            isAnotherWorkoutItem(i),
            navigateToWorkoutItemExecution,
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

class WorkoutItemCard extends StatefulWidget {
  WorkoutItem workoutItem;
  int position; // index of WorkoutItem in workoutItems list
  List<bool> blockStates;
  Function(int, [bool])
      navigate; // callback funciton for navigating to the WorkoutItem execuiton screen
  WorkoutItemCard(
      this.workoutItem, this.position, this.blockStates, this.navigate,
      {Key key})
      : super(key: key);

  @override
  _WorkoutItemCardState createState() =>
      _WorkoutItemCardState(workoutItem, position, blockStates, navigate);
}

class _WorkoutItemCardState extends State<WorkoutItemCard> {
  WorkoutItem workoutItem;
  int position;
  List<bool> blockStates;
  Function(int, [bool]) navigate;
  List<Widget> blocks = [];
  _WorkoutItemCardState(
      this.workoutItem, this.position, this.blockStates, this.navigate);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        color: myIndigo,
        elevation: 2.0,
        child: ListTile(
          title: Center(
              child: Text(
            workoutItem.name,
            style: whiteText,
          )),
          onTap: () {
            navigate(position, true);
          },
        ),
      ),
      drawProgressBlocks(WorkoutItem.sets)
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
