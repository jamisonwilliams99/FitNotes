class ExecutedSuperSet {
  int _id;
  int _superSetId;
  int _executedWorkoutId;

  ExecutedSuperSet.withExternalId(this._superSetId, this._executedWorkoutId);

  get id => _id;
  get superSetId => _superSetId;
  get executedWorkoutId => _executedWorkoutId;

  set id(int newId) {
    _id = newId;
  }

  set superSetId(int newSuperSetId) {
    _superSetId = newSuperSetId;
  }

  set executedWorkoutId(int newExecutedWorkoutId) {
    _executedWorkoutId = newExecutedWorkoutId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["superSetId"] = _superSetId;
    map["executedWorkoutId"] = _executedWorkoutId;

    if (_id == null) {
      map["executedSuperSetId"] = _id;
    }
    return map;
  }

  ExecutedSuperSet.fromObject(dynamic o) {
    this._id = o["executedSuperSetId"];
    this._superSetId = o["superSetId"];
    this._executedWorkoutId = o["executedWorkoutId"];
  }
}
