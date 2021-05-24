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

  int get id => _id;
  String get title => _title;
  List<Exercise> get exercises => _exercises;

  set id(int newId) {
    _id = newId;
  }

  set title(String newTitle) {
    _title = newTitle;
  }

  set exercises(List newExercises) {
    _exercises = newExercises;
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
    return map;
  }

  Workout.fromObject(dynamic o) {
    this._id = o["workoutId"];
    this._title = o["title"];
  }
}
