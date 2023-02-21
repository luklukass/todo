import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedExercises extends StatefulWidget {
  final String dayOfWeek;

  SavedExercises({required this.dayOfWeek});

  @override
  _SavedExercisesState createState() => _SavedExercisesState();
}

class _SavedExercisesState extends State<SavedExercises> {
  late Map<String, dynamic> _selectedExercises = {};

  @override
  void initState() {
    super.initState();
    _loadSelectedExercises();
  }

  Future<void> _loadSelectedExercises() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFilePath = '${dbDirectory.path}/${widget.dayOfWeek}.json';
    final file = File(dbFilePath);

    if (await file.exists()) {
      final String contents = await file.readAsString();
      setState(() {
        _selectedExercises = json.decode(contents);
      });
    } else {
      setState(() {
        _selectedExercises = {};
      });
    }
  }

  Future<void> _saveSelectedExercises() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFilePath = '${dbDirectory.path}/${widget.dayOfWeek}.json';
    final file = File(dbFilePath);
    await file.writeAsString(json.encode(_selectedExercises));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dayOfWeek),
      ),
      body: _selectedExercises == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _selectedExercises.isEmpty
          ? Center(
        child: Text('Žádné cviky'),
      )
          : ListView.builder(
        itemCount: _selectedExercises['selectedExercises'].length,
        itemBuilder: (BuildContext context, int index) {
          final exercise = _selectedExercises['selectedExercises'][index];

          return ListTile(
            title: Text('${exercise['name']} '),
            subtitle: Row(
              children: [
                Text('opakování: '),
                Flexible(
                  child: TextField(
                    controller: TextEditingController(text: exercise['repetitions']),
                    onChanged: (value) {
                      setState(() {
                        _selectedExercises['selectedExercises'][index]['repetitions'] = value;
                        _saveSelectedExercises();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text('čas: '),
                Flexible(
                  child: TextField(
                    controller: TextEditingController(text: exercise['time']),
                    onChanged: (value) {
                      setState(() {
                        _selectedExercises['selectedExercises'][index]['time'] = value;
                        _saveSelectedExercises();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Text('série: '),
                Flexible(
                  child: TextField(
                    controller: TextEditingController(text: exercise['series']),
                    onChanged: (value) {
                      setState(() {
                        _selectedExercises['selectedExercises'][index]['series'] = value;
                        _saveSelectedExercises();
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}