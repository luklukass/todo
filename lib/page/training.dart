import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SavedExercises extends StatefulWidget {
  final List selectedExercises;

  SavedExercises({required this.selectedExercises});

  @override
  _SavedExercisesState createState() => _SavedExercisesState();
}

class _SavedExercisesState extends State<SavedExercises> {
  List _exercises = [];

  Future<String> _loadCVikyAsset() async {
    return await rootBundle.loadString('assets/cviky.json');
  }

  Future<List<dynamic>> _getExercises() async {
    String jsonString = await _loadCVikyAsset();
    List<dynamic> exercises = jsonDecode(jsonString);
    return exercises;
  }

  @override
  void initState() {
    super.initState();
    _getExercises().then((exercises) {
      setState(() {
        _exercises = exercises;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List selectedExerciseDetails = [];

    for (var i = 0; i < _exercises.length; i++) {
      for (var j = 0; j < _exercises[i]['exercises'].length; j++) {
        if (widget.selectedExercises.contains(
            _exercises[i]['exercises'][j]['name'])) {
          selectedExerciseDetails.add({
            'name': _exercises[i]['exercises'][j]['name'],
            'title': _exercises[i]['title']
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Uložené cviky'),
      ),
      body: ListView.builder(
        itemCount: selectedExerciseDetails.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(selectedExerciseDetails[index]['name']),
            subtitle: Text(selectedExerciseDetails[index]['title']),
          );
        },
      ),
    );
  }
}