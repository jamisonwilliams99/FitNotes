import 'package:flutter/material.dart';
import 'package:workout_tracking_app/screens/executedworkoutdetail.dart';
import 'package:workout_tracking_app/screens/customappbar.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:workout_tracking_app/styles/styles.dart';

// Current goal: get a list of all of the executed workouts displayed
//               in order by date of execution
//
// Want to show: Name of workout that was was executed and the date of execution

class WorkoutExecutionList extends StatefulWidget {
  @override
  _WorkoutExecutionListState createState() => _WorkoutExecutionListState();
}

class _WorkoutExecutionListState extends State<WorkoutExecutionList> {
  DbHelper helper = DbHelper();
  List<ExecutedWorkout> executedWorkouts;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (executedWorkouts == null) {
      executedWorkouts = <ExecutedWorkout>[];
      getData();
    }
    return Scaffold(
        appBar: CustomAppBar("Workout History"), body: workoutExecutionList());
  }

  // Todo: implement
  // need to figure out how to just recieve one workout from the database with specified id
  ListView workoutExecutionList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          ExecutedWorkout currentWorkout = this.executedWorkouts[position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
            child: Card(
              color: myIndigo,
              child: ListTile(
                title: Center(
                    child: Text(
                  currentWorkout.title,
                  style: whiteText,
                )),
                subtitle: Center(
                  child: Text(currentWorkout.date),
                ),
                onTap: () {
                  navigateToWorkoutDetail(position);
                },
              ),
            ),
          );
        });
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final executedWorkoutsFuture = helper.getExecutedWorkouts();
      executedWorkoutsFuture.then((result) {
        List<ExecutedWorkout> workoutList = <ExecutedWorkout>[];
        count = result.length;
        for (int i = 0; i < result.length; i++) {
          ExecutedWorkout currentWorkout =
              ExecutedWorkout.fromObject(result[i]);
          workoutList.add(currentWorkout);
        }
        setState(() {
          executedWorkouts = workoutList;
          count = count;
        });
      });
    });
  }

  void navigateToWorkoutDetail(int position) async {
    ExecutedWorkout executedWorkout = executedWorkouts[position];
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExecutedWorkoutDetail(executedWorkout)));
  }
}
