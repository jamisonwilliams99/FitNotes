/*
ExecutedSet will be used to record the weight and reps that the user
uses when executed a set of a certain exercise.

It will require an additional table added to the database to record the ExecutedSet
The table will have an unique id generated for every ExecutedSet, but will also use 
the primary key of the Exercise being executed as a foreign key as well as another 
foreign key which will be used to identify the ExecutedWorkout that it is a part of.

Class attributes:
  id         (int)          primary key
  exerciseId (int)          foreign key
  executedWorkoutId (int)   foreing key
  weight     (double)
  reps       (int)

*/

class ExecutedSet {
  int _id;

  ExecutedSet();

  ExecutedSet.fromObject(dynamic o) {
    this._id = o["setId"];
  }

  // getters
  get id => _id;

  set id(int newId) {
    _id = newId;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map["setId"] = _id;
    }

    return map;
  }
}

class ExecutedSuperSet extends ExecutedSet {
  int _superSetId;
  int _executedWorkoutId;

  ExecutedSuperSet.withExternalId(this._superSetId, this._executedWorkoutId);

  ExecutedSuperSet.fromObject(dynamic o) : super.fromObject(o) {
    this._superSetId = o["superSetId"];
    this._executedWorkoutId = o["executedWorkoutId"];
  }

  get superSetId => _superSetId;
  get executedWorkoutId => _executedWorkoutId;

  set superSetId(int newSuperSetId) {
    _superSetId = newSuperSetId;
  }

  set executedWorkoutId(int newExecutedWorkoutId) {
    _executedWorkoutId = newExecutedWorkoutId;
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["superSetId"] = _superSetId;
    map["executedWorkoutId"] = _executedWorkoutId;

    return map;
  }
}

class ExecutedExerciseSet extends ExecutedSet {
  int _exerciseId;
  String _name;
  double _weight;
  int _reps;

  ExecutedExerciseSet(this._name, this._weight, this._reps);

  ExecutedExerciseSet.withExternalId(
      this._exerciseId, this._name, this._weight, this._reps);

  ExecutedExerciseSet.fromObject(dynamic o) : super.fromObject(o) {
    this._exerciseId = o["exerciseId"];
    this._name = o["name"];
    this._weight = o["weight"];
    this._reps = o["reps"];
  }

  get exerciseId => _exerciseId;
  get name => _name;
  get weight => _weight;
  get reps => _reps;

  set exerciseId(int newExerciseId) {
    _exerciseId = newExerciseId;
  }

  set name(String newName) {
    _name = newName;
  }

  set weight(double newWeight) {
    _weight = newWeight;
  }

  set reps(int newReps) {
    _reps = newReps;
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["exerciseId"] = _exerciseId;
    map["name"] = _name;
    map["weight"] = _weight;
    map["reps"] = _reps;

    return map;
  }
}

class ExecutedStandAloneExerciseSet extends ExecutedExerciseSet {
  int _executedWorkoutId;

  ExecutedStandAloneExerciseSet(name, weight, reps) : super(name, weight, reps);

  ExecutedStandAloneExerciseSet.withExternalId(
      this._executedWorkoutId, exerciseId, name, weight, reps)
      : super.withExternalId(exerciseId, name, weight, reps);

  ExecutedStandAloneExerciseSet.fromObject(dynamic o) : super.fromObject(o) {
    this._executedWorkoutId = o["executedWorkoutId"];
  }

  int get executedWorkoutId => _executedWorkoutId;

  set executedWorkoutId(int newExecutedWorkoutId) {
    _executedWorkoutId = newExecutedWorkoutId;
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["executedWorkoutId"] = _executedWorkoutId;
    return map;
  }
}

class ExecutedSuperSetExerciseSet extends ExecutedExerciseSet {
  int _executedSuperSetId;

  ExecutedSuperSetExerciseSet(name, weight, reps) : super(name, weight, reps);

  ExecutedSuperSetExerciseSet.withExternalId(
      this._executedSuperSetId, exerciseId, name, weight, reps)
      : super.withExternalId(exerciseId, name, weight, reps);

  ExecutedSuperSetExerciseSet.fromObject(dynamic o) : super.fromObject(o) {
    this._executedSuperSetId = o["executedSuperSetId"];
  }

  int get executedSuperSetId => _executedSuperSetId;

  set executedSuperSetId(int newExecutedSuperSetId) {
    _executedSuperSetId = newExecutedSuperSetId;
  }

  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["executedSuperSetId"] = _executedSuperSetId;
    return map;
  }
}
