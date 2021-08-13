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
import 'package:workout_tracking_app/model/superset.dart';
import 'package:workout_tracking_app/model/workoutitem.dart';
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
  List<WorkoutItem> workoutItems;
  Map<int, List> superSetExercises;
  int count = 0;

  _ExecutedWorkoutDetailState(this.executedWorkout);

  @override
  Widget build(BuildContext context) {
    if (workoutItems == null) {
      getData();
    }
    return Scaffold(
      appBar: CustomAppBar(executedWorkout.title),
      body: executedWorkoutItemList(),
    );
  }

  ListView executedWorkoutItemList() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, position) {
        WorkoutItem workoutItem = workoutItems[position];
        print(workoutItems);
        if (workoutItem is StandAloneExercise) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
            child: Card(
                child: Column(
              children: [
                ListTile(
                  title: Center(child: Text(workoutItem.name)),
                  subtitle: Center(child: Text("Tap to see exercise details")),
                  onTap: () {
                    navigateToExecutedExerciseDetail(position);
                  },
                )
              ],
            )),
          );
        } else {
          List<SuperSetExercise> exercises =
              this.superSetExercises[workoutItem.id];
          return Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
            child: Card(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    SuperSetExercise exercise = exercises[index];

                    Color separatorColor = (index < exercises.length - 1)
                        ? myIndigo
                        : Colors.white;

                    String subTitleText = (index == exercises.length - 1)
                        ? "Tap to see superset details"
                        : "";

                    return Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1.0, color: separatorColor)),
                      ),
                      child: ListTile(
                        title: Center(child: Text(exercise.name)),
                        subtitle: Center(
                          child: Text(subTitleText),
                        ),
                        onTap: () {
                          navigateToExecutedSuperSetDetail(position);
                        },
                      ),
                    );
                  }),
            ),
          );
        }
      },
    );
  }

  void getData() async {
    final dbFuture = await helper.initializeDb();
    final exercisesData =
        await helper.getStandAloneExercises(executedWorkout.workoutId);

    List<WorkoutItem> workoutItemList = <WorkoutItem>[];
    final Map<int, List> superSetMap = Map();
    count = exercisesData.length;

    for (int i = 0; i < exercisesData.length; i++) {
      StandAloneExercise exercise =
          StandAloneExercise.fromObject(exercisesData[i]);
      // exercise.executedSets =
      //     await getSets(exercise.id, executedWorkout.id, "exercise");
      workoutItemList.add(exercise);
    }

    final superSetsData = await helper.getSuperSets(executedWorkout.workoutId);

    count += superSetsData.length;

    for (int i = 0; i < superSetsData.length; i++) {
      WorkoutItem superSet = SuperSet.fromObject(superSetsData[i]);
      workoutItemList.add(superSet);

      var superSetExercisesData =
          await helper.getSuperSetExercises(superSet.id);

      List<SuperSetExercise> tempExercises = <SuperSetExercise>[];
      for (int j = 0; j < superSetExercisesData.length; j++) {
        SuperSetExercise superSetExercise =
            SuperSetExercise.fromObject(superSetExercisesData[j]);
        tempExercises.add(superSetExercise);
      }
      tempExercises.sort((a, b) => a.orderNum.compareTo(b.orderNum));
      superSetMap[superSet.id] = tempExercises;
    }

    workoutItemList.sort((a, b) => a.orderNum.compareTo(b.orderNum));

    setState(() {
      workoutItems = workoutItemList;
      superSetExercises = superSetMap;
      count = count;
    });
  }

  Future<List<ExecutedSet>> getSets(
      int workoutItemId, int executedWorkoutId, String itemType,
      [int superSetId]) async {
    var setsData;

    if (itemType == "exercise") {
      setsData = await helper.getExecutedStandAloneExerciseSets(
          executedWorkoutId, workoutItemId);
    } else {
      setsData =
          await helper.getExecutedSuperSets(executedWorkoutId, superSetId);
    }

    List<ExecutedSet> setsList = <ExecutedSet>[];
    for (int i = 0; i < setsData.length; i++) {
      setsList.add(ExecutedSet.fromObject(setsData[i]));
    }
    return setsList;
  }

  void navigateToExecutedExerciseDetail(position) async {
    StandAloneExercise exercise = workoutItems[position];
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExecutedExerciseDetail(exercise)));
  }

  void navigateToExecutedSuperSetDetail(position) async {}
}
