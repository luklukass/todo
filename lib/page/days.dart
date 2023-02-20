import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TrainingPlanner extends StatefulWidget {
  @override
  _TrainingPlannerState createState() => _TrainingPlannerState();
}

class _TrainingPlannerState extends State<TrainingPlanner> {
  List _exercises = [];
  List _selectedExercises = [];

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
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_getDayOfWeek(index + 1)),
            subtitle: Text('Vyber si cvik'),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
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
                                                  _selectedExercises.add(
                                                      _exercises[i]['exercises'][j]
                                                      ['name']);
                                                } else {
                                                  _selectedExercises.remove(
                                                      _exercises[i]['exercises'][j]
                                                      ['name']);
                                                }
                                              });
                                          }
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
                                // save selected exercises to database or file
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ]
            ),
          );
        },
      ),
    );
  }
}
