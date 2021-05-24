Create screen for actually doing workout
- allow user to track what set they are on and enter the weight that they used


Workout Execution page should:
- show a list of all of the exercise
- - each exercise should have a progress indicator showing how many sets the user has completed
- have a button to start the workout from the beginning
- - the user should be able to return to the base workout page at any time to see there overall progress
- - the user should also be able to start at any point in the workout by clicking on one of the exercises
- once on an exercise, the user should be able to cycle through each workout in order without returning to the base workout page
- - this will require the ability to dynamically push a new page to the stack for every exercise in the workout
- - 

WorkoutExecution
- widget that will serve as the main page for the workout execution
- contains the full list of exercises with their set progress
- will likely need to create a sub widget that packages the progress indicator and the exercise card together

ExerciseExecution
- widget that will be dynamically created for every exercise in the workout
- user will need to enter the weight and reps that were used
- when set is completed, the weight and reps used should be displayed inside of a listview







NEED TO FIX:
- in ExerciseExecution
- - when the weight is changed for a new set, it modifies the weight in all the other cards in the listview
- - this can be fixed by creating a list that stores the set information and indexing it with position variable


FEATURES THAT NEED TO BE IMPLEMENTED:

need to modify dbhelper so that it can save data from previously performed workouts
- weight used
- sets/reps actually done
- date user did workout
- PR for every exercise

add ability to do supersets