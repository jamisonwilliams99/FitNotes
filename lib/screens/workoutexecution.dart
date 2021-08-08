/*
This Widget will display the base page when a user begins an WorkoutItem
- it will need to receive the list of workoutItems from WorkoutView
*/

import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/workoutitem.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/superset.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/screens/exerciseexecution.dart';
import 'package:workout_tracking_app/screens/supersetexecution.dart';
import 'package:workout_tracking_app/styles/styles.dart';
import 'package:workout_tracking_app/util/noanimationpageroute.dart';

import '../model/exercise.dart';
import '../model/exercise.dart';
import '../model/exercise.dart';

class WorkoutExecution extends StatefulWidget {
  Workout workout;
  ExecutedWorkout executedWorkout;
  List<WorkoutItem> workoutItems;
  Map<int, List> superSetExercises;
  WorkoutExecution(this.workout, this.executedWorkout, this.workoutItems,
      this.superSetExercises);

  @override
  _WorkoutExecutionState createState() => _WorkoutExecutionState(
      workout, executedWorkout, workoutItems, superSetExercises);
}

class _WorkoutExecutionState extends State<WorkoutExecution> {
  Workout workout;
  ExecutedWorkout executedWorkout;
  List<WorkoutItem> workoutItems;
  Map<int, List> superSetExercises;
  List<List<bool>> workoutItemsetStates = [];
  List<int> completedSets;

  _WorkoutExecutionState(
      workout, executedWorkout, workoutItems, superSetExercises) {
    this.workout = workout;
    this.executedWorkout = executedWorkout;
    this.workoutItems = workoutItems;
    this.superSetExercises = superSetExercises;
    completedSets = List.generate(workoutItems.length, (index) => 0);
    populateStates();
  }

  void populateStates() {
    for (int i = 0; i < workoutItems.length; i++) {
      WorkoutItem workoutItem = workoutItems[i];
      print(workoutItem.sets);
      this
          .workoutItemsetStates
          .add(List.generate(workoutItem.sets, (index) => false));
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
        WorkoutItemCard workoutItemCard;
        if (currentWorkoutItem is StandAloneExercise) {
          workoutItemCard = WorkoutItemCard(currentWorkoutItem, position,
              workoutItemsetStates[position], navigateToWorkoutItemExecution);
        } else {
          workoutItemCard = WorkoutItemCard.isSuperSet(
              currentWorkoutItem,
              position,
              workoutItemsetStates[position],
              superSetExercises[currentWorkoutItem.id],
              navigateToWorkoutItemExecution);
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
          child: workoutItemCard,
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
    var execution; // execution screen to be visited will depend on workout item type

    if (!clickedCard) {
      anotherWorkoutItem = isAnotherWorkoutItem(position);

      if (workoutItems[position] is StandAloneExercise) {
        execution = ExerciseExecution(
            workoutItems[position],
            executedWorkout,
            completedSets[position],
            position,
            anotherWorkoutItem,
            navigateToWorkoutItemExecution,
            completeSet);
      } else {
        execution = SuperSetExecution(
            workoutItems[position],
            executedWorkout,
            completedSets[position],
            position,
            anotherWorkoutItem,
            navigateToWorkoutItemExecution,
            completeSet);
      }

      bool result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => execution));
    } else {
      for (int i = 0; i <= position; i++) {
        if (workoutItems[i] is StandAloneExercise) {
          execution = ExerciseExecution(
              workoutItems[i],
              executedWorkout,
              completedSets[i],
              i,
              isAnotherWorkoutItem(i),
              navigateToWorkoutItemExecution,
              completeSet);
        } else {
          execution = SuperSetExecution(
              workoutItems[i],
              executedWorkout,
              completedSets[i],
              i,
              isAnotherWorkoutItem(i),
              navigateToWorkoutItemExecution,
              completeSet);
        }
        pushWithoutAnimation(execution);
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
  List<SuperSetExercise> superSetExercises;
  Function(int, [bool])
      navigate; // callback funciton for navigating to the WorkoutItem execuiton screen
  WorkoutItemCard(
      this.workoutItem, this.position, this.blockStates, this.navigate,
      {Key key})
      : super(key: key);

  WorkoutItemCard.isSuperSet(this.workoutItem, this.position, this.blockStates,
      this.superSetExercises, this.navigate,
      {Key key})
      : super(key: key);

  @override
  _WorkoutItemCardState createState() {
    if (workoutItem is StandAloneExercise) {
      return _WorkoutItemCardState(
          workoutItem, position, blockStates, navigate);
    } else {
      return _WorkoutItemCardState.isSuperSet(
          workoutItem, position, blockStates, superSetExercises, navigate);
    }
  }
}

class _WorkoutItemCardState extends State<WorkoutItemCard> {
  WorkoutItem workoutItem;
  int position;
  List<bool> blockStates;
  List<SuperSetExercise> superSetExercises;
  Function(int, [bool]) navigate;
  List<Widget> blocks = [];
  _WorkoutItemCardState(
      this.workoutItem, this.position, this.blockStates, this.navigate);

  _WorkoutItemCardState.isSuperSet(this.workoutItem, this.position,
      this.blockStates, this.superSetExercises, this.navigate);

  @override
  Widget build(BuildContext context) {
    Function card;
    if (workoutItem is StandAloneExercise) {
      card = exerciseCard;
    } else {
      card = superSetCard;
    }
    return Column(children: [card(), drawProgressBlocks(workoutItem.sets)]);
  }

  Card exerciseCard() {
    StandAloneExercise exercise = workoutItem;
    return Card(
      color: myIndigo,
      elevation: 2.0,
      child: ListTile(
        title: Center(
            child: Text(
          exercise.name,
          style: whiteText,
        )),
        onTap: () {
          print(position);
          navigate(position, true);
        },
      ),
    );
  }

  Card superSetCard() {
    SuperSet superSet = workoutItem;
    return Card(
      color: myIndigo,
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: superSetExercises.length,
        itemBuilder: (context, index) {
          SuperSetExercise exercise = superSetExercises[index];
          Color separatorColor =
              (index < superSetExercises.length - 1) ? Colors.white : myIndigo;
          return Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1.0, color: separatorColor)),
            ),
            child: ListTile(
              title: Center(child: Text(exercise.name, style: whiteText)),
              onTap: () {},
            ),
          );
        },
      ),
    );
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
