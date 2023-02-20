import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TrainingPlanner extends StatefulWidget {
  @override
  _TrainingPlannerState createState() => _TrainingPlannerState();
}

class _TrainingPlannerState extends State<TrainingPlanner> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Planner'),
      ),
      body: ListView.builder(
        itemCount: 7, // one for each day of the week
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('Day ${index + 1}'),
            subtitle: Text('Select exercises for this day'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // show dialog with exercise options
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Select Exercises'),
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
                                    value: false,
                                    onChanged: (bool? value) {},
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
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Save'),
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
          );
        },
      ),
    );
  }
}
