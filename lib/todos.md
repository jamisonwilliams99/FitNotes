Current testing branch:
adding_supersets

CURRENTLY WORKING ON:

add a listview to display the executed super set data

- add functionality to record the superset exercises in superSetExecution
- - will need to modify ExecutedSet to accept SuperSets
- - I just finished modifying the inheritance hierchy of ExecutedSet
- - Now I need to modify the Workout/Exercise Execution screens to accept the different objects correctly
- - first need to modify database methods to accept the different objects

Current issue:




FEATURES THAT NEED TO BE IMPLEMENTED:
- add function to complete workout button in WorkoutExecution

- add ability to do supersets
- - add a supersetId attribute to exercise class
- - supersetId is null by default
- - supersetId is the id of the next exercise in the superset
- - add a isSuperSet attribute as well
- -   - boolean value indicating if exercise is in a superset

- add ability to search for a workout name in 

- add stopwatch to workout execution

- allow user to reorder exercises in workout




Needs fixed:

- workout execution needs to be modified to accept supersets
- - exercise and superset execution will be different widgets that inherit from WorkoutItemExecution
- - either that or completely different widgets which redefine the same methods (not ideal)

-workout/set execution needs to be modified to accept supersets (needs to take WorkoutItem instead of Exercise)

- when a workout is deleted:
    - need to delete all exercises and supersets with that workout
    -   - also need to delete all exercises within each superset that is deleted

- order attributes of exercises and supersets need to be updated when 
  items are added and removed from lists

- when changing the order of exercises in WorkoutView, the animation causes the setsxreps subtitle in the card to shift down
- - also, there is a weird border placed around the card

- don't allow users to have duplicate workout names

- an executed workout should not be tracked unless a set is actually completed

- add input validation to entire app

- changes made to a workout after it has been executed will be applied to saved workout executions

Refactoring:
- make getData functions more readable
- - split them up into different functions

- make delete() functions more readable





OPTIMIZATION:
- optimize input validation in ExerciseExecution
- dispose of controllers to prevent memory leaks
- may need to get rid of getSets() in executedworkoutdetail.dart and just add a getData() method to executedexercisedetail.dart
- - not sure which is more optimal




