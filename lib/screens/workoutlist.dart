import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/screens/workoutview.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';

class WorkoutList extends StatefulWidget {
  @override
  _WorkoutListState createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  DbHelper helper = DbHelper();
  List<Workout> workouts;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: workoutList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigateToWorkoutView(Workout("Untitled Workout"));
        },
        label: Text("Add New Workout"),
        icon: Icon(Icons.add),
      ),
    );
  }

  TextStyle textStyle = TextStyle(
    color: Colors.white,
  );

  ListView workoutList() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          Workout currentWorkout = this.workouts[position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
            child: Card(
              color: Colors.indigo,
              child: ListTile(
                  title: Center(
                      child: Text(
                    currentWorkout.title,
                    style: textStyle,
                  )),
                  onTap: () {
                    navigateToWorkoutView(currentWorkout);
                  }),
            ),
          );
        });
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final workoutsFuture = helper.getWorkouts();
      workoutsFuture.then((result) {
        List<Workout> workoutList = <Workout>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          Workout currentWorkout = Workout.fromObject(result[i]);
          workoutList.add(currentWorkout);
        }
        setState(() {
          count = count;
          workouts = workoutList;
        });
      });
    });
  }

  void navigateToWorkoutView(Workout workout) async {
    if (workout.id != null) {
      helper.updateWorkout(workout);
    } else {
      workout.id = await helper.insertWorkout(workout);
    }
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WorkoutView(workout)));
    if (result == true) {
      getData();
    }
  }
}
