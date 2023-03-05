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
import 'package:training_planner_v1/page/days.dart';

class SavedExercises extends StatefulWidget {
  final String dayOfWeek;
  final List<Map<String, dynamic>> selectedExercises;

  SavedExercises({required this.dayOfWeek, required this.selectedExercises});//requited argument for this widget

  @override
  _SavedExercisesState createState() => _SavedExercisesState();
}

class _SavedExercisesState extends State<SavedExercises> {
  List<Map<String, dynamic>> _selectedExercises = [];//declaring of selected, editable exercises list


  //////////////////////////////////////
  Future<void> saveSelectedExercisesToJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.dayOfWeek}.json');
    final jsonData = jsonEncode(_selectedExercises);
    await file.writeAsString(jsonData);
  }

//////////////////////////////////////
  Future<void> loadSelectedExercisesFromJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${widget.dayOfWeek}.json');
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final selectedExercises = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
      setState(() {
        _selectedExercises = selectedExercises;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    loadSelectedExercisesFromJson();
    _selectedExercises = widget.selectedExercises;
  }

  @override
  Widget build(BuildContext context) {

    //call function to load file
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

          child: _selectedExercises.isEmpty //if the list with selected exercises is empty write message to the screen
            ? Center(
          child: Text('Nevybrány žádné cviky',// message
            style: TextStyle(// setting of text - color, size
              fontSize: 30,
              color: Colors.red,
            ),),
        )
            : ListView.builder(
          itemCount: _selectedExercises.length,//number of selected exercises
          itemBuilder: (BuildContext context, int index) {// build context for the widget
            final exercise = _selectedExercises[index];// every selected exercise on index
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
                      controller: TextEditingController(text: _selectedExercises[index]['repetitions']),// save the written value to the repetition in JSON
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises[index]['repetitions'] = value;//save the value to the relevant exercise
                          saveSelectedExercisesToJson();// call function to save the value
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
                      controller: TextEditingController(text: _selectedExercises[index]['time']),// save the written value to the time in JSON
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises[index]['time'] = value;//save the value to the relevant exercise
                          saveSelectedExercisesToJson();//call function to save the value
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
                  Text('série: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),

                  ),
                  Flexible(
                    child: TextField(
                      controller: TextEditingController(text: _selectedExercises[index]['series']),// save the written value to the series in JSON
                      onChanged: (value) {
                        setState(() {
                          _selectedExercises[index]['series'] = value;//save the value to the relevant exercise
                          saveSelectedExercisesToJson();//call function to save the value
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
                      _selectedExercises.removeAt(index);// remove exercise from the list
                      // call function to save changed exercises
                      saveSelectedExercisesToJson();
                    },
                  );
                },
            ),
            );
          },
        ),
      ),

    );
  }
}