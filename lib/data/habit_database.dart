import 'package:flutter/scheduler.dart';
import 'package:flutter_habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Reference our box
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

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

    // Calculate habit complete percentage for each day
    calculateHabitPercentages();

    // Load heat map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0,0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    // Key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // Value: string of 1dp number between 0,0 - 1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // Count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // Go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // Split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // Year
      int year = startDate.add(Duration(days: i)).year;

      // Month
      int month = startDate.add(Duration(days: i)).month;

      // Day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
