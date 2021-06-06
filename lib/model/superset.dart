import 'workoutitem.dart';

class SuperSet implements WorkoutItem {
  int _id;
  int _workoutId;

  SuperSet(this._id);
  SuperSet.fromObject(dynamic o) {
    this._id = o["superSetId"];
    this._workoutId = o["workoutId"];
  }

  get id => _id;

  set id(int newId) {
    _id = newId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["workoutId"] = _workoutId;
    if (_id != null) {
      map["superSetId"] = _id;
    }
  }
}
