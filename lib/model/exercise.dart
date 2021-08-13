import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/model/workoutitem.dart';

class Exercise implements WorkoutItem {
  int _id;
  String _name;
  int _reps;
  int _sets;
  int _orderNum;

  Exercise(this._name, this._reps, this._sets, this._orderNum);

  Exercise.withId(this._id, this._name, this._reps, this._sets, this._orderNum);

  Exercise.fromObject(dynamic o) {
    this._id = o["id"];
    this._name = o["name"];
    this._reps = o["reps"];
    this._sets = o["sets"];
    this._orderNum = o["orderNum"];
  }

  // getters
  int get id => _id;
  String get name => _name;
  int get reps => _reps;
  int get sets => _sets;
  int get orderNum => _orderNum;

  // setters
  set name(String newName) {
    _name = newName;
  }

  set id(int newId) {
    _id = newId;
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
}

class StandAloneExercise extends Exercise {
  int _workoutId;
  List<ExecutedStandAloneExerciseSet> executedSets;

  StandAloneExercise(name, reps, sets, orderNum)
      : super(name, reps, sets, orderNum);

  StandAloneExercise.withId(id, name, reps, sets, orderNum)
      : super.withId(id, name, reps, sets, orderNum);

  StandAloneExercise.withWorkoutId(this._workoutId, name, reps, sets, orderNum)
      : super(name, reps, sets, orderNum);

  StandAloneExercise.fromObject(dynamic o) : super.fromObject(o) {
    this._workoutId = o["workoutId"];
  }

  // getters
  int get workoutId => _workoutId;

  // setters
  set workoutId(int newWorkoutId) {
    _workoutId = newWorkoutId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["workoutId"] = _workoutId;
    map["name"] = super._name;
    map["reps"] = super._reps;
    map["sets"] = super._sets;
    map["orderNum"] = super._orderNum;
    if (super._id != null) {
      map["id"] = super._id;
    }
    return map;
  }
}

class SuperSetExercise extends Exercise {
  int _superSetId;

  SuperSetExercise(name, reps, sets, orderNum)
      : super(name, reps, sets, orderNum);

  SuperSetExercise.withId(id, name, reps, sets, orderNum)
      : super.withId(id, name, reps, sets, orderNum);

  SuperSetExercise.withSuperSetId(this._superSetId, name, reps, sets, orderNum)
      : super(name, reps, sets, orderNum);

  SuperSetExercise.fromObject(dynamic o) : super.fromObject(o) {
    this._superSetId = o["superSetId"];
  }

  // getters
  int get superSetId => _superSetId;

  // setters
  set superSetId(int newSuperSetId) {
    _superSetId = newSuperSetId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["superSetId"] = _superSetId;
    map["name"] = super._name;
    map["reps"] = super._reps;
    map["sets"] = super._sets;
    map["orderNum"] = super._orderNum;
    if (super._id != null) {
      map["id"] = super._id;
    }
    return map;
  }
}
