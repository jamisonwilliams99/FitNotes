import 'package:workout_tracking_app/model/executedset.dart';
import 'workoutitem.dart';

class SuperSet implements WorkoutItem {
  int _id;
  int _sets;
  int _workoutId;
  int _orderNum;

  List<ExecutedSuperSet> executedSets;

  SuperSet.withWorkoutId(this._workoutId, this._orderNum);

  SuperSet.fromObject(dynamic o) {
    this._id = o["superSetId"];
    this._sets = o["sets"];
    this._workoutId = o["workoutId"];
    this._orderNum = o["orderNum"];
  }

  get id => _id;
  get sets => _sets;
  get orderNum => _orderNum;

  set id(int newId) {
    _id = newId;
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
    map["sets"] = _sets;
    map["orderNum"] = _orderNum;
    if (_id != null) {
      map["superSetId"] = _id;
    }
    return map;
  }
}
