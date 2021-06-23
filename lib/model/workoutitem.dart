abstract class WorkoutItem {
  int _id;
  int _sets;
  int _orderNum;

  set id(int newId);
  set sets(int newSets);
  set orderNum(int newOrderNum);

  get id;
  get sets;
  get orderNum;
}
