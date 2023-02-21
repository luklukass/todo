import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:todo/page/training.dart';

class TrainingPlanner extends StatefulWidget {
  @override
  _TrainingPlannerState createState() => _TrainingPlannerState();
}

class _TrainingPlannerState extends State<TrainingPlanner> {
  List _exercises = [];
  List _selectedExercises = [];


  Future<void> _saveSelectedExercises(String dayOfWeek) async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFilePath = '${dbDirectory.path}/$dayOfWeek.json';
    final file = File(dbFilePath);

    // Read the existing JSON data from the file
    Map<String, dynamic> jsonData = {};
    if (await file.exists()) {
      final String contents = await file.readAsString();
      jsonData = json.decode(contents);
    }

    // Update the selected exercises for the current day
    if (!jsonData.containsKey('selectedExercises')) {
      jsonData['selectedExercises'] = [];
    }
    jsonData['selectedExercises'] = _selectedExercises;

    // Write the updated JSON data back to the file
    await file.writeAsString(json.encode(jsonData));
  }

  Future<String> _loadexerciseyAsset() async {
    return await rootBundle.loadString('assets/cviky.json');
  }

  Future<List<dynamic>> _getExercises() async {
    String jsonString = await _loadexerciseyAsset();
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


  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Pondělí';
      case DateTime.tuesday:
        return 'Úterý';
      case DateTime.wednesday:
        return 'Středa';
      case DateTime.thursday:
        return 'Čtvrtek';
      case DateTime.friday:
        return 'Pátek';
      case DateTime.saturday:
        return 'Sobota';
      case DateTime.sunday:
        return 'Neděle';
      default:
        throw Exception('Špatný den');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plánovač tréninku'),
      ),
      body: ListView.builder(
        itemCount: 7, // one for each day of the week
        itemBuilder: (BuildContext context, int index) => ListTile(
          title: Text(_getDayOfWeek(index+ 1)),
          subtitle: Text('Vyber si cvik'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_right),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SavedExercises(
                          dayOfWeek: _getDayOfWeek(index+ 1),
                        );
                      },
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Výběr cviků'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List<Widget>.generate(
                              _exercises.length,
                                  (int i) {
                                return ExpansionTile(
                                  title: Text(_exercises[i]['title']),
                                  children: List<Widget>.generate(
                                    _exercises[i]['exercises'].length,
                                        (int j) {
                                      return CheckboxListTile(
                                        title: Text(
                                            _exercises[i]['exercises'][j]['name']),
                                        value: _selectedExercises.contains(
                                            _exercises[i]['exercises'][j]['name']),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value == true) {
                                              value = true;
                                              if (!_selectedExercises.contains(_exercises[i]['exercises'][j]['name'])) {
                                                _selectedExercises.add(_exercises[i]['exercises'][j]['name']);
                                              }
                                            } else {
                                              _selectedExercises.remove(
                                                  _exercises[i]['exercises'][j]
                                                  ['name']);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Zrušit'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Uložit'),
                            onPressed: () {
                              final dayOfWeek = _getDayOfWeek(index + 1);
                              _saveSelectedExercises(dayOfWeek);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}