import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

// TODO
class Excercise {
  String name;
  String reps;
  String sets;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          //primarySwatch: Colors.indigo
          ),
      home: Homepage(),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("PR Tracker"),
        backgroundColor: Colors.indigo[300],
      ),
      body: WorkoutCreationWidget(),
    );
  }
}

class WorkoutCreationWidget extends StatefulWidget {
  @override
  _WorkoutCreationWidgetState createState() => _WorkoutCreationWidgetState();
}

class _WorkoutCreationWidgetState extends State<WorkoutCreationWidget> {
  List<Excercise> exercises = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //ExerciseList(this.exercises),
      ExerciseWidget(),
      RaisedButton(
          onPressed: () {},
          color: Colors.indigo[300],
          textColor: Colors.white,
          child: Text("+ Add Exercise"))
    ]);
  }
}

class ExerciseWidget extends StatefulWidget {
  @override
  _ExerciseWidgetState createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.indigo[300],
        margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: Table(
          children: [
            TableRow(children: [
              Container(
                  margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Center(
                    child: Text("Flat Bench Press",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  )),
              Container(
                  decoration: BoxDecoration(
                      border: Border(left: BorderSide(color: Colors.grey))),
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Column(children: <Widget>[
                    TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            labelText: "Reps:",
                            labelStyle: TextStyle(color: Colors.white))),
                    TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Sets:",
                          labelStyle: TextStyle(color: Colors.white),
                        ))
                  ]))
            ])
          ],
        ));
  }
}

class TextInputWidget extends StatefulWidget {
  final Function(String) callback;
  TextInputWidget(this.callback);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField();
  }
}

class ExerciseList extends StatefulWidget {
  final List<Excercise> exercises;

  ExerciseList(this.exercises);

  @override
  _ExerciseListState createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.widget.exercises.length,
        itemBuilder: (context, index) {
          var exercise = this.widget.exercises[index];
          return Card(
              child: Table(
            children: [
              TableRow(children: [
                Container(child: Text("Exercise name")),
                Container(
                    child: Column(children: <Widget>[
                  TextField(decoration: InputDecoration(labelText: "Reps:")),
                  TextField(decoration: InputDecoration(labelText: "Sets"))
                ]))
              ])
            ],
          ));
        });
  }
}
