import 'package:flutter/material.dart';

class SelectedExercisesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> selectedExercises;

  SelectedExercisesWidget({required this.selectedExercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Exercises'),
      ),
      body: ListView.builder(
        itemCount: selectedExercises.length,
        itemBuilder: (BuildContext context, int index) {
          final exercise = selectedExercises[index];
          return ListTile(
            title: Text(exercise['name']),
            subtitle: Text(exercise['description']),
          );
        },
      ),
    );
  }
}