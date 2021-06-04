
FEATURES THAT NEED TO BE IMPLEMENTED:
- add ability to do supersets
- add ability to search for a workout name in 
- add stopwatch to workout execution
- allow user to reorder exercises in workout




Needs fixed:
- an executed workout should not be tracked unless a set is actually completed
- add input validation to entire app
- need to add button on the last exercise in a exercise execution to "complete workout"
- - this should save the workout execution


OPTIMIZATION:
- optimize input validation in ExerciseExecution
- dispose of controllers to prevent memory leaks
- may need to get rid of getSets() in executedworkoutdetail.dart and just add a getData() method to executedexercisedetail.dart
- - not sure which is more optimal

