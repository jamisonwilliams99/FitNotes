import 'package:workout_tracking_app/model/executedset.dart';

class Exercise {
  int _id;
  int _workoutId;
  String _name;
  int _reps;
  int _sets;
  int _orderNum;

  List<ExecutedSet> executedSets;

  Exercise(this._name, this._reps, this._sets);

  Exercise.withId(this._id, this._name, this._reps, this._sets,
      this._orderNum); // still need to add workoutId to this

  Exercise.withWorkoutId(
      this._workoutId, this._name, this._reps, this._sets, this._orderNum);

  // getters
  int get id => _id;
  int get workoutId => _workoutId;
  String get name => _name;
  int get reps => _reps;
  int get sets => _sets;
  int get orderNum => _orderNum;

  // setters
  set workoutId(int newWorkoutId) {
    _workoutId = newWorkoutId;
  }

  set name(String newName) {
    _name = newName;
  }

  set reps(int newReps) {
    _reps = newReps;
  }

  set sets(int newSets) {
    _sets = newSets;
  }

  set orderNum(int newOrderNum) {
    _orderNum = newOrderNum;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["workoutId"] = _workoutId;
    map["name"] = _name;
    map["reps"] = _reps;
    map["sets"] = _sets;
    map["orderNum"] = _orderNum;

    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Exercise.fromObject(dynamic o) {
    this._id = o["id"];
    this._workoutId = o["workoutId"];
    this._name = o["name"];
    this._reps = o["reps"];
    this._sets = o["sets"];
    this._orderNum = o["orderNum"];
  }
}
