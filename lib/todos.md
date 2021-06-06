Current testing branch:
adding_supersets

CURRENTLY WORKING ON:
    Trying to get ReorderableListView working properly in WorkoutView



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
- when changing the order of exercises in WorkoutView, the animation causes the setsxreps subtitle in the card to shift down
- - also, there is a weird border placed around the card

- don't allow users to have duplicate workout names

- an executed workout should not be tracked unless a set is actually completed

- add input validation to entire app



OPTIMIZATION:
- optimize input validation in ExerciseExecution
- dispose of controllers to prevent memory leaks
- may need to get rid of getSets() in executedworkoutdetail.dart and just add a getData() method to executedexercisedetail.dart
- - not sure which is more optimal


Adding supersets:
Create a new class SuperSet
- will contain a list of exercise IDs
- - these exercises will be included in the superset

Create a generic class WorkoutItem
- Exercise and SuperSet will implement WorkoutItem

Attributes: 
  id
  workoutId
  orderNum

