import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/screens/workoutexecution.dart';
import 'package:workout_tracking_app/screens/workoutview.dart';
import 'package:workout_tracking_app/screens/workoutlist.dart';
import 'package:workout_tracking_app/screens/workoutexecutionlist.dart';
import 'package:workout_tracking_app/styles/styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: myIndigo,
          primarySwatch: Colors.indigo,
          scaffoldBackgroundColor: Colors.grey[400]),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("FitNotes"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: myIndigo,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: 100.0,
                  width: 100.0,
                  child: Image.asset(
                    'lib/assets/FitNotes Logo.png',
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      navigateToWorkoutList();
                    },
                    child: Text("View Saved Workouts")),
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      navigateToWorkoutExecutionList();
                    },
                    child: Text("View Workout History")),
              )
            ],
          ),
        ));
  }

  void navigateToWorkoutList() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => WorkoutList()));
  }

  void navigateToWorkoutExecutionList() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => WorkoutExecutionList()));
  }
}
