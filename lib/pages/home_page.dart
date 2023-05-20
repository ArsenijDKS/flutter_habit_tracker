import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/components/habit_tile.dart';
import 'package:flutter_habit_tracker/components/my_fab.dart';
import 'package:flutter_habit_tracker/components/new_habit_box.dart';

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
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // Show alert message for user to enter the new habit
    showDialog(
      context: context,
      builder: (context) {
        return EnterNewHabitBox(
          controller: _newHabitNameController,
          onSave: saveNewHabit,
          onCancel: cancelNewHabit,
        );
      },
    );
  }

  // Function for saving a new habit
  void saveNewHabit() {
    // Add new habit to the list
    setState(() {
      todayHabitList.add([_newHabitNameController.text, false]);
    });

    // Clearing the textfield
    _newHabitNameController.clear();

    // Pop the dialog box
    Navigator.of(context).pop();
  }

  // Function for cancelling a new habit
  void cancelNewHabit() {
    // Clearing the textfield
    _newHabitNameController.clear();

    // Pop the dialog box
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: createNewHabit,
      ),
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
