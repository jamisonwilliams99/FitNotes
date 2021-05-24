/*
ExecutedSet will be used to record the weight and reps that the user
uses when executed a set of a certain exercise.

It will require an additional table added to the database to record the ExecutedSet
The table will have an unique id generated for every ExecutedSet, but will also use 
the primary key of the Exercise being executed as a foreign key

Class attributes:
  id         (int)          primary key
  exerciseId (int)          foreign key
  weight     (double)
  reps       (int)
  date       (string)

*/

class ExecutedSet {
  int _id;
  int _exerciseId;
  double _weight;
  int _reps;
  String _date;

  // getters
  get id => _id;
  get exerciseId => _exerciseId;
  get weight => _weight;
  get reps => _reps;
  get date => _date;

  // setters
  set exerciseId(int newExerciseId) {
    _exerciseId = newExerciseId;
  }

  set weight(double newWeight) {
    _weight = newWeight;
  }

  set reps(int newReps) {
    _reps = newReps;
  }

  set date(String newDate) {
    _date = newDate;
  }
}
