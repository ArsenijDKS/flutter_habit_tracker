import 'package:flutter_habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];

  // Create initial default data
  void createDefaultData() {
    todaysHabitList = [
      ["Run", false],
      ["Read", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // Load already existing data
  void loadData() {
    // If it's a new day - get habit list from database
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");

      // Set all habit complition to false since it's a new day
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }
    // If it's not a new day - load todays list
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  // Update database
  void updateDatabase() {
    // Update todays entry
    _myBox.put(todaysDateFormatted(), todaysHabitList);

    // Update universal habit list in case it changed
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
  }
}
