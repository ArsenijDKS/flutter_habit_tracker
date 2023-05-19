import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final bool habitCompleted;

  final Function(bool?)? onChanged;

  const HabitTile(
      {super.key,
      required this.habitName,
      required this.habitCompleted,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            // CheckBox
            Checkbox(
              value: habitCompleted,
              onChanged: onChanged,
            ),

            // Habit Name
            Text(habitName)
          ],
        ),
      ),
    );
  }
}
