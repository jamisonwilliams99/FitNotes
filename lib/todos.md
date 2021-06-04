CURRENTLY WORKING ON:
    Trying to get ReorderableListView working properly in WorkoutView



FEATURES THAT NEED TO BE IMPLEMENTED:
- add function to complete workout button in WorkoutExecution
- add ability to do supersets
- add ability to search for a workout name in 
- add stopwatch to workout execution
- allow user to reorder exercises in workout




Needs fixed:
- when the order of exercises is changed in WorkoutView, it is not saved
- - this will require a order number field to be added to the exercises database in the exercises table
- -   - Fixed this, the order is just not maintained in the saved workout execution

- when changing the order of exercises in WorkoutView, the animation causes the setsxreps subtitle in the card to shift down
- - also, there is a weird border placed around the card

- an executed workout should not be tracked unless a set is actually completed

- add input validation to entire app



OPTIMIZATION:
- optimize input validation in ExerciseExecution
- dispose of controllers to prevent memory leaks
- may need to get rid of getSets() in executedworkoutdetail.dart and just add a getData() method to executedexercisedetail.dart
- - not sure which is more optimal

