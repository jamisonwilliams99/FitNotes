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
  int _exerciseId;
  int _executedWorkoutId;
  double _weight;
  int _reps;

  ExecutedSet(this._weight, this._reps);

  ExecutedSet.withExternalId(
      this._exerciseId, this._executedWorkoutId, this._weight, this._reps);

  // getters
  get id => _id;
  get exerciseId => _exerciseId;
  get executedWorkoutId => _executedWorkoutId;
  get weight => _weight;
  get reps => _reps;

  // setters
  set exerciseId(int newExerciseId) {
    _exerciseId = newExerciseId;
  }

  set executedWorkoutId(int newExecutedWorkoutId) {
    _executedWorkoutId = newExecutedWorkoutId;
  }

  set weight(double newWeight) {
    _weight = newWeight;
  }

  set reps(int newReps) {
    _reps = newReps;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["exerciseId"] = _exerciseId;
    map["executedWorkoutId"] = _executedWorkoutId;
    map["weight"] = _weight;
    map["reps"] = _reps;

    if (_id != null) {
      map["setId"] = _id;
    }
    return map;
  }

  ExecutedSet.fromObject(dynamic o) {
    this._id = o["setId"];
    this._exerciseId = o["exerciseId"];
    this._executedWorkoutId = o["executedWorkoutId"];
    this._weight = o["weight"];
    this._reps = o["reps"];
  }
}
