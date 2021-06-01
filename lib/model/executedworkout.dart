/*
ExecutedWorkout will be used to record the date that a created workout
is executed by the user. 

It will require an additional table to be added to the database to record the ExecutedWorkout.
The table will have a unique id generated for each ExecutedWorkout, which will be used
as a foreign key to the ExecutedSet table to identify which ExecutedSets are a part of
this ExecutedWorkout

Class attributes:
  id        (int) primary key
  workoutId (int) foreign key
  date      (string) 
*/

class ExecutedWorkout {
  int _id;
  int _workoutId;
  String _date;
  String _title;

  ExecutedWorkout(this._date, this._title);

  ExecutedWorkout.withWorkoutId(this._workoutId, this._date, this._title);

  // getters
  get id => _id;
  get workoutId => _workoutId;
  get date => _date;
  get title => _title;

  // setters
  set id(int newId) {
    _id = newId;
  }

  set workoutId(int newWorkoutId) {
    _workoutId = newWorkoutId;
  }

  set date(String newDate) {
    _date = newDate;
  }

  set title(String newTitle) {
    _title = newTitle;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["date"] = _date;
    map["title"] = _title;
    map["workoutId"] = _workoutId;

    if (_id != null) {
      map["executedWorkoutId"] = _id;
    }
    return map;
  }

  ExecutedWorkout.fromObject(dynamic o) {
    this._id = o["executedWorkoutId"];
    this._workoutId = o["workoutId"];
    this._date = o["date"];
    this._title = o["title"];
  }
}
