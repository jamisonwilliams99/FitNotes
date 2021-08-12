import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_tracking_app/model/executedworkout.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/superset.dart';
import 'package:workout_tracking_app/model/executedset.dart';
import 'package:workout_tracking_app/screens/addexercise.dart';
import 'package:workout_tracking_app/util/noanimationpageroute.dart';
import 'package:workout_tracking_app/styles/styles.dart';

class SuperSetExecution extends StatefulWidget {
  SuperSet superSet;
  ExecutedWorkout executedWorkout;
  int numCompletedSets;
  int position;
  bool clickedCard;
  int counter;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;

  SuperSetExecution(this.superSet, this.executedWorkout, this.numCompletedSets,
      this.position, this.anotherExercise, this.navigate, this.completeSet);

  @override
  _SuperSetExecutionState createState() => _SuperSetExecutionState(
      superSet,
      executedWorkout,
      numCompletedSets,
      position,
      anotherExercise,
      navigate,
      completeSet);
}

class _SuperSetExecutionState extends State<SuperSetExecution> {
  SuperSet superSet;
  ExecutedWorkout executedWorkout;
  int numCompletedSets;
  int position;
  bool clickedCard;
  int counter;
  bool anotherExercise;
  Function(int) navigate;
  Function(void) completeSet;

  List<SuperSetExercise> exercises;
  List<ExecutedSuperSet> executedSuperSets = <ExecutedSuperSet>[];
  Map<int, List> executedSuperSetExerciseSets = Map();
  int count = 0;
  int indexOfCurrentExercise = 0;
  String repsErrorText;
  String weightErrorText;
  bool validReps = false;
  bool validWeight = false;

  _SuperSetExecutionState(
      this.superSet,
      this.executedWorkout,
      this.numCompletedSets,
      this.position,
      this.anotherExercise,
      this.navigate,
      this.completeSet);

  TextEditingController repsController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  ExecutedSuperSet currentExecutedSuperSet;

  @override
  Widget build(BuildContext context) {
    if (exercises == null) {
      exercises = <SuperSetExercise>[];
      getExerciseData();
      getExecutedSetData();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Super Set"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                  onTap: () {
                    if (anotherExercise) {
                      navigateToNextExercise();
                    } else {
                      navigateToWorkoutExecution(context);
                    }
                  },
                  child: Icon(
                    Icons.arrow_forward,
                  )),
            )
          ],
        ),
        body: Column(
          children: [
            // need some sort of method here for dynamically displaying exercises
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: generateExerciseWidgets(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: repsController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => validateRepsInput(),
                      decoration: InputDecoration(
                          labelText: "Reps",
                          errorText: repsErrorText,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => validateWeightInput(),
                      decoration: InputDecoration(
                          labelText: "Weight",
                          errorText: weightErrorText,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                // make this a function (should be called in the completeSetWrapper() function)
                onPressed: () {
                  completeSetWrapper();
                },
                child: Text("Complete Set")),
            Expanded(child: superSetList())
          ],
        ));
  }

  ListView superSetList() {
    return ListView.builder(
        itemCount: executedSuperSets.length,
        itemBuilder: (BuildContext context, int position) {
          int superSetId = executedSuperSets[position].id;
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: myIndigo, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                Center(child: Text("Set " + (position + 1).toString())),
                exerciseSetList(superSetId),
              ],
            ),
          );
        });
  }

  // implement this the same way as superSetCard in exerciseexecution
  ListView exerciseSetList(int superSetId) {
    List<ExecutedSuperSetExerciseSet> exerciseSets =
        executedSuperSetExerciseSets[superSetId];
    // print(executedSuperSetExerciseSets);
    // print(executedSuperSets);
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: exerciseSets.length,
      itemBuilder: (context, index) {
        ExecutedSuperSetExerciseSet executedSet = exerciseSets[index];
        Color separatorColor =
            (index < exerciseSets.length - 1) ? myIndigo : Colors.white;
        return Container(
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1.0, color: separatorColor)),
          ),
          child: ListTile(
            title: Text(executedSet.name),
            subtitle: Text("Reps: " +
                executedSet.reps.toString() +
                "   Weight: " +
                executedSet.weight.toString() +
                " lbs"),
          ),
        );
      },
    );
  }

  void completeSetWrapper() async {
    double weight = double.parse(weightController.text);
    int reps = int.parse(repsController.text);
    ExecutedSuperSetExerciseSet executedSet;

    if (indexOfCurrentExercise < exercises.length - 1) {
      if (indexOfCurrentExercise == 0) {
        // we are creating a new ExecutedSet Object
        // all executed exercise info will point to this executedSuperSet
        // until the index reaches 0 again, in which case a new executedSuperSet will be created
        currentExecutedSuperSet =
            ExecutedSuperSet.withExternalId(superSet.id, executedWorkout.id);

        // need to insert executedSuperSet to database but first need to modify database method to accept this object
        currentExecutedSuperSet.id =
            await helper.insertExecutedSet(currentExecutedSuperSet);
      }
      SuperSetExercise exercise = exercises[indexOfCurrentExercise];
      executedSet = ExecutedSuperSetExerciseSet.withExternalId(
          currentExecutedSuperSet.id, exercise.id, exercise.name, weight, reps);

      setState(() {
        indexOfCurrentExercise++;
      });
    } else {
      SuperSetExercise exercise = exercises[indexOfCurrentExercise];
      executedSet = ExecutedSuperSetExerciseSet.withExternalId(
          currentExecutedSuperSet.id, exercise.id, exercise.name, weight, reps);

      setState(() {
        indexOfCurrentExercise = 0;
        numCompletedSets = completeSet(position);
      });
    }
    await helper.insertExecutedSet(executedSet);
    getExecutedSetData();
  }

  List<Widget> generateExerciseWidgets() {
    TextStyle textStyle;
    Color exerciseColor;

    TextStyle currentExerciseTextStyle =
        TextStyle(color: Colors.white, fontSize: 15);

    TextStyle otherExerciseTextStyle =
        TextStyle(color: Colors.grey[800], fontSize: 15);

    return List.generate(exercises.length, (index) {
      if (index == indexOfCurrentExercise) {
        textStyle = currentExerciseTextStyle;
        exerciseColor = myIndigo;
      } else {
        textStyle = otherExerciseTextStyle;
        exerciseColor = Colors.transparent;
      }
      return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: exerciseColor, borderRadius: BorderRadius.circular(10)),
            child: Text(exercises[index].name, style: textStyle)),
      );
    });
  }

  void validateRepsInput() {
    String input = repsController.text;
    if (input.contains('.')) {
      setState(() {
        repsErrorText = "Number of reps cannots be a decimal value";
        validReps = false;
      });
    } else {
      setState(() {
        repsErrorText = null;
        validReps = true;
      });
    }
  }

  void validateWeightInput() {
    String input = weightController.text;
    int numPeriods = '.'.allMatches(input).length;
    if (numPeriods > 1) {
      setState(() {
        weightErrorText = "Invalid input";
        validWeight = false;
      });
    } else {
      setState(() {
        weightErrorText = null;
        validWeight = true;
      });
    }
  }

  // Todo: implement
  void getExerciseData() async {
    final db = await helper.initializeDb();
    final exercisesData = await helper.getSuperSetExercises(superSet.id);

    List<SuperSetExercise> exerciseList = <SuperSetExercise>[];

    for (int i = 0; i < exercisesData.length; i++) {
      SuperSetExercise exercise = SuperSetExercise.fromObject(exercisesData[i]);
      exerciseList.add(exercise);
    }

    setState(() {
      exercises = exerciseList;
    });
  }

  void getExecutedSetData() async {
    final db = await helper.initializeDb();
    final executedSuperSetsData =
        await helper.getExecutedSuperSets(executedWorkout.id, superSet.id);

    List<ExecutedSuperSet> executedSuperSetList = <ExecutedSuperSet>[];
    final Map<int, List> executedSuperSetMap = Map();

    await Future.forEach(executedSuperSetsData, (data) async {
      ExecutedSuperSet executedSuperSet = ExecutedSuperSet.fromObject(data);
      List<ExecutedSuperSetExerciseSet> tempSets =
          <ExecutedSuperSetExerciseSet>[];

      executedSuperSetList.add(executedSuperSet);

      var exerciseSetData =
          await helper.getExecutedSuperSetExerciseSets(executedSuperSet.id);

      for (int i = 0; i < exerciseSetData.length; i++) {
        ExecutedSuperSetExerciseSet tempSet =
            ExecutedSuperSetExerciseSet.fromObject(exerciseSetData[i]);

        tempSets.add(tempSet);
      }
      executedSuperSetMap[executedSuperSet.id] = tempSets;
    });

    setState(() {
      executedSuperSets = executedSuperSetList;
      executedSuperSetExerciseSets = executedSuperSetMap;
    });
  }

  void navigateToNextExercise() {
    navigate(position + 1);
  }

  void navigateToWorkoutExecution(BuildContext context) {
    for (int i = position; i >= 0; i--) {
      Navigator.pop(context);
    }
  }
}
