import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/workout.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  String tblExercise = "exercise";
  String colId = "id";
  String colName = "name";
  String colReps = "reps";
  String colSets = "sets";

  String tblWorkout = "workout";
  String colWorkoutId = "workoutId";
  String colWorkoutTitle = "title";

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
        "CREATE TABLE $tblExercise($colId INTEGER PRIMARY KEY, $colName TEXT," +
            "$colReps INTEGER, $colSets INTEGER, $colWorkoutId INTEGER, " +
            "FOREIGN KEY($colWorkoutId) REFERENCES $tblWorkout($colWorkoutId))");
  }

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
    result = await db
        .rawDelete("DELETE FROM $tblExercise WHERE $colWorkoutId = $id");
    return result;
  }

  Future<int> insertExercise(Exercise exercise) async {
    Database db = await this.db;
    var result = await db.insert(tblExercise, exercise.toMap());
    return result;
  }

  // Get all exercises that are a part of the current workout
  Future<List> getExercises(int workoutId) async {
    Database db = await this.db;
    var result = db.rawQuery(
        "SELECT * FROM $tblExercise WHERE $colWorkoutId = $workoutId");
    return result;
  }

  Future<List> getAllExercises() async {
    Database db = await this.db;
    var result = db.rawQuery("SELECT * FROM $tblExercise");
    return result;
  }

  Future<int> getExerciseCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT (*) FROM $tblExercise"));
    return result;
  }

  Future<int> updateExercise(Exercise exercise) async {
    var db = await this.db;
    var result = await db.update(tblExercise, exercise.toMap(),
        where: "$colId = ?", whereArgs: [exercise.id]);
    return result;
  }

  Future<int> deleteExercise(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete("DELETE FROM $tblExercise WHERE $colId = $id");
    return result;
  }
}
