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
    _loadSelectedExercises();
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.black87,
        title: Text(widget.dayOfWeek),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/vybaveni.jpg'), // Replace with your image file path
            fit: BoxFit.cover,
          ),
        ),
        child: _selectedExercises == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : _selectedExercises.isEmpty
            ? Center(
          child: Text('Nevybrány žádné cviky',
            style: TextStyle(
              fontSize: 30,
              color: Colors.red,
            ),),
        )
            : ListView.builder(
          itemCount: _selectedExercises['selectedExercises'].length,
          itemBuilder: (BuildContext context, int index) {
            final exercise = _selectedExercises['selectedExercises'][index];

            return ListTile(
              title: Text('${exercise['name']} ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,),
              subtitle: Row(
                children: [
                  Text('opakování: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  Flexible(
                    child: TextField(
                      controller: TextEditingController(text: exercise['repetitions']),
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises['selectedExercises'][index]['repetitions'] = value;
                          _saveSelectedExercises();
                        });
                      },
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('čas: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  Flexible(
                    child: TextField(
                      controller: TextEditingController(text: exercise['time']),
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises['selectedExercises'][index]['time'] = value;
                          _saveSelectedExercises();
                        });
                      },
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('série: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  Flexible(
                    child: TextField(
                      controller: TextEditingController(text: exercise['series']),
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises['selectedExercises'][index]['series'] = value;
                          _saveSelectedExercises();
                        });
                      },
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],

              ),
              trailing: IconButton(
                icon: Icon(Icons.delete,
                    color: Colors.redAccent, // set the icon color to blue
                    size: 30),
                onPressed: () {
                  setState(() {
                    _selectedExercises['selectedExercises'].removeAt(index);
                    _saveSelectedExercises();

                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}