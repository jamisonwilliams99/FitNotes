import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';
import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();

  // Exercise Table
  String tblStandAloneExercise = "standAloneExercise";
  String tblSuperSetExercise = "superSetExercise";
  String colId = "id";
  String colName = "name";
  String colReps = "reps";
  String colSets = "sets";
  String colOrderNum = "orderNum";

  // Workout table
  String tblWorkout = "workout";
  String colWorkoutId = "workoutId";
  String colWorkoutTitle = "title";

  // SuperSetTable
  String tblSuperSet = "superSet";
  String colSuperSetId = "superSetId";

  // Executed Workout table
  String tblExecutedWorkout = "executedWorkout";
  String colExWorkoutId = "executedWorkoutId";
  String colDate = "date";

  // Executed Set table
  String tblSets = "sets";
  String colSetId = "setId";
  String colExerciseId = "exerciseId";
  String colWeight = "weight";
  String colExReps = "reps"; // watch this

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "exercises.db";
    var dbExercises = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbExercises;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblWorkout($colWorkoutId INTEGER PRIMARY KEY, $colWorkoutTitle TEXT)");

    await db.execute(
        "CREATE TABLE $tblSuperSet($colSuperSetId INTEGER PRIMARY KEY, $colWorkoutId INTEGER, FOREIGN KEY($colWorkoutId) REFERENCES $tblWorkout($colWorkoutId))");

    await db.execute(
        "CREATE TABLE $tblStandAloneExercise($colId INTEGER PRIMARY KEY, $colName TEXT," +
            "$colReps INTEGER, $colSets INTEGER, $colOrderNum INTEGER, $colWorkoutId INTEGER, " +
            "FOREIGN KEY($colWorkoutId) REFERENCES $tblWorkout($colWorkoutId))");

    await db.execute(
        "CREATE TABLE $tblSuperSetExercise($colId INTEGER PRIMARY KEY, $colName TEXT," +
            "$colReps INTEGER, $colSets INTEGER, $colOrderNum INTEGER, $colWorkoutId INTEGER, $colSuperSetId INTEGER, " +
            "FOREIGN KEY($colSuperSetId) REFERENCES $tblSuperSet($colSuperSetId))");

    await db.execute(
        "CREATE TABLE $tblExecutedWorkout($colExWorkoutId INTEGER PRIMARY KEY," +
            "$colDate TEXT, $colWorkoutTitle TEXT, $colWorkoutId INTEGER, " +
            "FOREIGN KEY($colWorkoutId) REFERENCES $tblWorkout($colWorkoutId))");

    // this will need to be fixed later
    await db.execute("CREATE TABLE $tblSets($colSetId INTEGER PRIMARY KEY, " +
        "$colWeight REAL, $colExReps INTEGER, $colName TEXT, $colExWorkoutId INTEGER, $colExerciseId INTEGER, " +
        "FOREIGN KEY($colExWorkoutId) REFERENCES $tblExecutedWorkout($colExWorkoutId), " +
        "FOREIGN KEY($colExerciseId) REFERENCES $tblStandAloneExercise($colId))");
  }

  // *** WORKOUT TABLE METHODS ***
  Future<int> insertWorkout(Workout workout) async {
    Database db = await this.db;
    var result = await db.insert(tblWorkout, workout.toMap());
    return result;
  }

  Future<List> getWorkouts() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblWorkout");
    return result;
  }

  Future<int> getWorkoutCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM $tblWorkout"));
    return result;
  }

  Future<int> updateWorkout(Workout workout) async {
    var db = await this.db;
    var result = await db.update(tblWorkout, workout.toMap(),
        where: "$colWorkoutId = ?", whereArgs: [workout.id]);
    return result;
  }

  Future<int> deleteWorkout(int id) async {
    int result;
    var db = await this.db;
    result =
        await db.rawDelete("DELETE FROM $tblWorkout WHERE $colWorkoutId = $id");
    return result;
  }

  // Deletes all of the exercises in a workout; called alongside deleteWorkout()
  Future<int> deleteWorkoutExercises(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete(
        "DELETE FROM $tblStandAloneExercise WHERE $colWorkoutId = $id");
    return result;
  }
  // *** END WORKOUT TABLE METHODS ***

  // *** EXERCISE TABLE METHODS ***
  Future<int> insertStandAloneExercise(StandAloneExercise exercise) async {
    Database db = await this.db;
    var result = await db.insert(tblStandAloneExercise, exercise.toMap());
    return result;
  }

  // Get all exercises that are a part of the current workout
  Future<List> getStandAloneExercises(int workoutId) async {
    Database db = await this.db;
    var result = db.rawQuery(
        "SELECT * FROM $tblStandAloneExercise WHERE $colWorkoutId = $workoutId");
    return result;
  }

  Future<List> getAllStandAloneExercises() async {
    Database db = await this.db;
    var result = db.rawQuery("SELECT * FROM $tblStandAloneExercise");
    return result;
  }

  Future<int> getStandAloneExerciseCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM $tblStandAloneExercise"));
    return result;
  }

  Future<int> updateStandAloneExercise(StandAloneExercise exercise) async {
    var db = await this.db;
    var result = await db.update(tblStandAloneExercise, exercise.toMap(),
        where: "$colId = ?", whereArgs: [exercise.id]);
    return result;
  }

  Future<int> deleteStandAloneExercise(int id) async {
    int result;
    var db = await this.db;
    result = await db
        .rawDelete("DELETE FROM $tblStandAloneExercise WHERE $colId = $id");
    return result;
  }
  // *** END EXERCISE TABLE METHODS ***

  // *** SET TABLE METHODS ***
  Future<int> insertExecutedSet(ExecutedSet executedSet) async {
    Database db = await this.db;
    var result = await db.insert(tblSets, executedSet.toMap());
    return result;
  }

  // gets all sets in the database that are a part of a specific executed workout and for a specific exercise
  Future<List> getExecutedSets(int executedWorkoutId, int exerciseId) async {
    Database db = await this.db;
    var result = db.rawQuery(
        "SELECT * FROM $tblSets WHERE $colExWorkoutId = $executedWorkoutId AND $colExerciseId = $exerciseId");
    return result;
  }

  Future deleteExecutedSet(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $tblSets WHERE $colSetId = $id");
    return result;
  }
  // *** END SET TABLE METHODS ***

  // *** ExecutedWorkout TABLE METHODS ***
  Future<int> insertExecutedWorkout(ExecutedWorkout executedWorkout) async {
    Database db = await this.db;
    var result = await db.insert(tblExecutedWorkout, executedWorkout.toMap());
    return result;
  }

  Future<List> getExecutedWorkouts() async {
    Database db = await this.db;
    var result = db.rawQuery("SELECT * FROM $tblExecutedWorkout");
    return result;
  }

  // *** END ExecutedWorkout TABLE METHODS ***
}
