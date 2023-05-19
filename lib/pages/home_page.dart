import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/components/habit_tile.dart';
import 'package:flutter_habit_tracker/components/my_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data structure for today habit list
  List todayHabitList = [
    // [ habitName, habitCompleted ]
    ["Morning Run", false],
    ["Reading a book", false],
    ["Code App", false],
  ];

  // Checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      todayHabitList[index][1] = value;
    });
  }

  // Create a new habit
  void createNewHabit() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(),
      body: ListView.builder(
        itemCount: todayHabitList.length,
        itemBuilder: (context, index) {
          return HabitTile(
              habitName: todayHabitList[index][0],
              habitCompleted: todayHabitList[index][1],
              onChanged: (value) => checkBoxTapped(value, index));
        },
      ),
    );
  }
}
