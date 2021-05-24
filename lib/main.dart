import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/screens/workoutview.dart';
import 'package:workout_tracking_app/screens/workoutlist.dart';
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
      theme: ThemeData(primaryColor: myIndigo, primarySwatch: Colors.indigo),
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
        title: Row(children: [
          Text("FitNotes"),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Image.asset(
              'lib/assets/app_logo.png',
              height: 50.0,
              width: 50.0,
            ),
          ),
        ]),
      ),
      body: WorkoutList(),
    );
  }
}
