import 'workoutitem.dart';

class SuperSet implements WorkoutItem {
  int _id;
  int _workoutId;
  int _orderNum;

  SuperSet.withWorkoutId(this._workoutId, this._orderNum);

  SuperSet.fromObject(dynamic o) {
    this._id = o["superSetId"];
    this._workoutId = o["workoutId"];
    this._orderNum = o["orderNum"];
  }

  get id => _id;

  get orderNum => _orderNum;

  set id(int newId) {
    _id = newId;
  }

  set orderNum(int newOrderNum) {
    _orderNum = newOrderNum;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["workoutId"] = _workoutId;
    map["orderNum"] = _orderNum;
    if (_id != null) {
      map["superSetId"] = _id;
    }
    return map;
  }
}
