/*
Lichnovsky Lukas

Feb 2023

KMI/XPROJ

This file is to create widget with selected exercises for certain day
*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedExercises extends StatefulWidget {
  final String dayOfWeek;

  SavedExercises({required this.dayOfWeek});//requited argument for this widget

  @override
  _SavedExercisesState createState() => _SavedExercisesState();
}

class _SavedExercisesState extends State<SavedExercises> {
  late Map<String, dynamic> _selectedExercises = {};//declaring of selected, editable exercises list


  Future<void> _loadSelectedExercises() async {//function to load exercise from database for certain day
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFilePath = '${dbDirectory.path}/${widget.dayOfWeek}.json';//load JSON file
    final file = File(dbFilePath);

    if (await file.exists()) {//condition to if file exists
      final String contents = await file.readAsString();
      setState(() {
        _selectedExercises = json.decode(contents);// decode content of JSON file
      });
    } else {
      setState(() {
        _selectedExercises = {};//if file not exist create empty database
      });
    }
  }

  Future<void> _saveSelectedExercises() async {//function to save edited selected exercises
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFilePath = '${dbDirectory.path}/${widget.dayOfWeek}.json';//save to JSON file to certain day
    final file = File(dbFilePath);
    await file.writeAsString(json.encode(_selectedExercises));//write values to file
  }

  @override
  Widget build(BuildContext context) {
    _loadSelectedExercises();//call function to load file
    return Scaffold(
      appBar: AppBar(//header of screen
        backgroundColor:Colors.black87,//background of screen
        title: Text(widget.dayOfWeek),//header text - selected day of week
      ),
      body: Container(
        decoration: const BoxDecoration(// decoration of background of screen - widget selected exercises
          image: DecorationImage(
            image: AssetImage('assets/vybaveni.jpg'), // image to background
            fit: BoxFit.cover,
          ),
        ),
        child: _selectedExercises == null //if list not exist
            ? Center(
          child: CircularProgressIndicator(),// make loading circle
        )
            : _selectedExercises.isEmpty //if the list with selected exercises is empty write message to the screen
            ? Center(
          child: Text('Nevybrány žádné cviky',// message
            style: TextStyle(// setting of text - color, size
              fontSize: 30,
              color: Colors.red,
            ),),
        )
            : ListView.builder(
          itemCount: _selectedExercises['selectedExercises'].length,//number of selected exercises
          itemBuilder: (BuildContext context, int index) {// build context for the widget
            final exercise = _selectedExercises['selectedExercises'][index];// every selected exercise on index

            return ListTile(
              title: Text('${exercise['name']} ',//title of exercise
                style: TextStyle(// setting of text - color, size, bold
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,),
              subtitle: Row(//create row with children
                children: [
                  Text('opakování: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  Flexible(
                    child: TextField(// editable textfield
                      controller: TextEditingController(text: exercise['repetitions']),// save the written value to the repetition in JSON
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises['selectedExercises'][index]['repetitions'] = value;//save the value to the relevant exercise
                          _saveSelectedExercises();// call function to save the value
                        });
                      },
                      style: TextStyle(// setting of visual of text
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),// size of editable box
                  Text('čas: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),

                  ),
                  Flexible(
                    child: TextField(
                      controller: TextEditingController(text: exercise['time']),// save the written value to the time in JSON
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises['selectedExercises'][index]['time'] = value;//save the value to the relevant exercise
                          _saveSelectedExercises();//call function to save the value
                        });
                      },
                      style: TextStyle(// setting of visual of text
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                      // here is not define input type - can be due to input values like 2min, 30s etc.
                    ),
                  ),
                  SizedBox(width: 10),// size of editable box
                  Text('série: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),

                  ),
                  Flexible(
                    child: TextField(
                      controller: TextEditingController(text: exercise['series']),// save the written value to the series in JSON
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises['selectedExercises'][index]['series'] = value;//save the value to the relevant exercise
                          _saveSelectedExercises();//call function to save the value
                        });
                      },
                      style: TextStyle(// setting of visual of text
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

              ),
              trailing: IconButton(// display Icon button in every exercise
                icon: Icon(Icons.delete,//icon is delete
                    color: Colors.redAccent, // set the icon color to red
                    size: 30),
                onPressed: () {//what to do on pressed
                  setState(() {
                    _selectedExercises['selectedExercises'].removeAt(index);// remove exercise from the list
                    _saveSelectedExercises();// call function to save changed exercises

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