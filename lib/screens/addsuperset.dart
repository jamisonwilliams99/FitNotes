import 'package:flutter/material.dart';
import 'package:workout_tracking_app/model/exercise.dart';
import 'package:workout_tracking_app/model/superset.dart';
import 'package:workout_tracking_app/screens/customappbar.dart';
import 'package:workout_tracking_app/util/dbhelper.dart';
import 'package:workout_tracking_app/styles/styles.dart';

DbHelper helper = DbHelper();

class AddSuperSet extends StatefulWidget {
  final SuperSet superSet;

  AddSuperSet(this.superSet);

  @override
  _AddSuperSetState createState() => _AddSuperSetState(superSet);
}

class _AddSuperSetState extends State<AddSuperSet> {
  SuperSet superSet;
  List<SuperSetExercise> exercises;
  int count = 0;

  _AddSuperSetState(this.superSet);

  TextEditingController nameController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController setsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (exercises == null) {
      exercises = <SuperSetExercise>[];
      getData();
    }
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar("Add Superset"),
        body: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(50.0, 30.0, 50.0, 20.0),
            child: Center(
                child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: "Exercise name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            )),
          ),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
                child: TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Reps",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 0.0),
                child: TextField(
                  controller: setsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Sets",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
              ),
            ),
          ]),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    addExercise();
                  });
                },
                child: Text("Add Exercise")),
          ),
          Expanded(child: superSetExerciseList()),
        ]),
      ),
      onWillPop: () {
        Navigator.pop(context, true);
      },
    );
  }

  ReorderableListView superSetExerciseList() {
    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        bool movedForward = false;
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
            movedForward = true;
          }
          SuperSetExercise exercise = exercises.removeAt(oldIndex);
          exercises.insert(newIndex, exercise);
          updateExerciseOrder(oldIndex, newIndex, movedForward);
        });
      },
      padding: EdgeInsets.fromLTRB(50.0, 15, 50.0, 0.0),
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        SuperSetExercise currentExercise = this.exercises[position];
        child:
        return Card(
          key: ValueKey(currentExercise.id),
          color: myIndigo,
          elevation: 2.0,
          child: ListTile(
            title: Center(
              child: Text(
                currentExercise.name,
                style: whiteText,
              ),
            ),
            subtitle: Center(
              child: Text(
                  currentExercise.sets.toString() +
                      "x" +
                      currentExercise.reps.toString(),
                  style: whiteText),
            ),
          ),
        );
      },
    );
  }

  void updateExerciseOrder(int oldIndex, int newIndex, bool movedForward) {
    exercises[newIndex].orderNum = newIndex + 1;
    if (movedForward) {
      for (int i = oldIndex; i < newIndex; i++) {
        exercises[i].orderNum--;
      }
    } else {
      for (int i = newIndex + 1; i <= oldIndex; i++) {
        exercises[i].orderNum++;
      }
    }
    for (int i = 0; i < exercises.length; i++) {
      helper.updateSuperSetExercise(exercises[i]);
    }
  }

  // removes the exercise from the list view as well removes any info added to
  // the database for the exercise
  //   - will likely add a button to the exercise card to access this function
  void deleteExercise(int position) async {
    SuperSetExercise exercise = exercises[position];
    int result;
    result = await helper.deleteSuperSetExercise(exercise.id);

    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(content: Text("Exercise deleted"));
      showDialog(context: context, builder: (_) => alertDialog);
    }

    getData();
  }

  // will delete the superset from the workout as well as any info saved to the
  // database
  //   - will also need to call the deleteExercise() function on all of the
  //     exercises in the list to delete their info from the listview as well
  void deleteSuperSet() async {
    int result;
    Navigator.pop(context, true);
    if (superSet.id == null) {
      return;
    }

    for (int i = 0; i < exercises.length; i++) {
      deleteExercise(i);
    }

    result = await helper.deleteSuperSet(superSet.id);

    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(content: Text("Super set deleted"));
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  // adds and exercise to the superset
  // the user wiil need to have the exercise name, reps, and sets filled in
  // before adding
  //   - will also need to save exercise info to the database
  //   - exercise will then show up in the list view
  void addExercise() {
    String name = nameController.text;
    int reps = repsController.text == "" ? 0 : int.parse(repsController.text);
    int sets = setsController.text == "" ? 0 : int.parse(setsController.text);
    SuperSetExercise exercise = SuperSetExercise.withSuperSetId(
        superSet.id, name, reps, sets, exercises.length + 1);

    helper.insertSuperSetExercise(exercise);
    getData();
  }

  void getData() {
    final dbFuture = helper.initializeDb();

    dbFuture.then((result) {
      final exercisesFuture = helper.getSuperSetExercises(superSet.id);
      exercisesFuture.then((result) {
        List<SuperSetExercise> exerciseList = <SuperSetExercise>[];
        count = result.length;
        for (int i = 0; i < count; i++) {
          SuperSetExercise currentExercise =
              SuperSetExercise.fromObject(result[i]);
          exerciseList.add(currentExercise);
        }
        exerciseList.sort((a, b) => a.orderNum.compareTo(b.orderNum));
        setState(() {
          count = count;
          exercises = exerciseList;
        });
      });
    });
  }

  // will be essentially the add exercise screen where the user can edit
  // an exercise that has already been added to the superset
  //   - accessed by tapping the exercise card
  void navigateToExerciseEditor() {}
}
