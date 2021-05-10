/*
This file contains the Workout class
---
A Workout object contains:
  - A list of Exercises objects
  - a name for the workout (For example: Leg Day)
  - number of exercises

*/

import 'exercise.dart';

class Workout {
  int _id;
  String _title;
  List<Exercise> _exercises;

  Workout(this._title);

  Workout.withId(this._id, this._title);

  String get title => _title;
  List<Exercise> get exercises => _exercises;

  set title(String newTitle) {
    _title = newTitle;
  }

  void addExercise(Exercise exercise) {
    _exercises.add(exercise);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    if (_id != null) {
      map["workoutId"] = _id;
    }
  }

  Workout.fromObject(dynamic o) {
    this._id = o["workoutId"];
    this._title = o["title"];
  }
}
