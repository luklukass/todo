/*
Lichnovsky Lukas
Feb 2023
KMI/XPROJ
This is a file to create a home page with days of the week and then a selection of exercises from the database
*/

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:training_planner_v1/page/training.dart';

class TrainingPlanner extends StatefulWidget {
  @override
  _TrainingPlannerState createState() => _TrainingPlannerState();
}

class _TrainingPlannerState extends State<TrainingPlanner> {
  List _exercises = []; //list of all exercises
  List<Map<String, dynamic>> _selectedExercises = []; //list of selected exercises


  Future<void> _saveSelectedExercises(String dayOfWeek) async { //function to save selected exercises
    final dbDirectory = await getApplicationDocumentsDirectory();// path to store user generated app data
    final dbFilePath = '${dbDirectory.path}/$dayOfWeek.json'; // load exercises from JSON file, where name of this file depends on selected day of week
    final file = File(dbFilePath);


    Map<String, dynamic> jsonData = {};
    if (await file.exists()) {
      final String contents = await file.readAsString();// read the existing JSON data from the file
      jsonData = json.decode(contents);
    }


    if (!jsonData.containsKey('selectedExercises')) {
      jsonData['selectedExercises'] = [];// update the selected exercises for the current day
    }
    jsonData['selectedExercises'] = _selectedExercises.map((exercise) { // mapping of JSON file
      return {
        'name': exercise['name'],
        'repetition': exercise['repetition'],
        'time': exercise['time'],
        'series': exercise['series'],
      };
    }).toList();


    await file.writeAsString(json.encode(jsonData)); // write the updated JSON data back to the file
  }

  Future<String> _loadexerciseAsset() async { //loading of main exercise database
    return await rootBundle.loadString('assets/cviky.json');
  }

  Future<List<dynamic>> _getExercises() async { //getting of exercises from previous loading function
    String jsonString = await _loadexerciseAsset();
    List<dynamic> exercises = jsonDecode(jsonString);
    return exercises;
  }



  @override
  void initState() { // it is method which is called when app is started and exercises loaded
    super.initState();// entry point to all app
    _getExercises().then((exercises) {
      setState(() {
        _exercises = exercises;
      });
    });
  }


  String _getDayOfWeek(int weekday) {// function to get day of week
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
      appBar: AppBar( //header of home page
        backgroundColor:Colors.black87,// setting o background color
        title: Text('Tréninkový plánovač'),//displayed header text
      ),
      body: Container(
        decoration: const BoxDecoration(//setting of background of home page
          image: DecorationImage(
            image: AssetImage('assets/vybaveni.jpg'), // image from assets as background
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(

          itemCount: 7, // one for each day of the week
          itemBuilder: (BuildContext context, int index) => ListTile(// create  list with days of week
            title: Text(_getDayOfWeek(index+ 1),//create title for every day
                style: TextStyle(color: Colors.yellowAccent,//setting style of text
                    fontWeight: FontWeight.bold,
                    fontSize: 23)),
            subtitle: Text('Vyber si cvik',//subtitle for every day
                style: TextStyle(color: Colors.deepOrangeAccent,//setting style of subtitle
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
            trailing: Row(//create row with buttons - icons
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(//button
                  icon: Icon(Icons.keyboard_arrow_right,//arrow icon to button
                    color: Colors.redAccent, // set the icon color to red
                    size: 30,),
                  onPressed: () {//what to do on pressed of icon
                    Navigator.of(context).push(//navigate to new screen
                      MaterialPageRoute(//
                        builder: (BuildContext context) {
                          return SavedExercises(//new screen -widget - file training.dart
                            dayOfWeek: _getDayOfWeek(index+ 1),//required data to the new screen - widget file training.dart
                          );
                        },
                      ),
                    );
                  },
                ),
                IconButton(//button
                  icon: Icon(Icons.add,//add icon of button
                      color: Colors.redAccent, // set the icon color to red
                      size: 30),
                  onPressed: () {//what to do on pressed of icon
                    _selectedExercises.clear();// this is was added due problem with adding exercises to certain day, now this list is cleaned after click on every add icon
                    showDialog(//show dialog window
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog( // create dialog window
                          title: Text('Výběr cviků'),// title of dialog
                          content: SingleChildScrollView(//simple scrolling of widget
                            child: Column(//return column with children
                              mainAxisSize: MainAxisSize.min,// in column is main axis vertical - this set the min of height of children
                              children: List<Widget>.generate(//generating of partition list
                                _exercises.length,// length of list
                                    (int i) {
                                  return ExpansionTile(// create expansion/ collapse partition field - it is possible to see exercises to certain partition
                                    title: Text(_exercises[i]['title']),//title of partition
                                    children: List<Widget>.generate(//generating of exercises list
                                      _exercises[i]['exercises'].length,// length of list
                                          (int j) {
                                        return TextButton(// every exercise is button
                                          onPressed: () {// set what to do on pressed

                                            setState(() {

                                              _selectedExercises.add({//on pressed add exercise to the list with selected exercises
                                                'name': _exercises[i]['exercises'][j]['name'],
                                                'repetition': _exercises[i]['exercises'][j]['repetition'],
                                                'time': _exercises[i]['exercises'][j]['time'],
                                                'series': _exercises[i]['exercises'][j]['series'],
                                              });
                                              _saveSelectedExercises(_getDayOfWeek(index+1));//calling of function to save this list for current day
                                            });
                                          },
                                          child: Container(// setting of visual of button
                                            decoration: BoxDecoration(
                                                color: Colors.black54,//set color of button
                                                borderRadius: BorderRadius.all(Radius.circular(5))//set circular corners of button
                                            ),
                                            width: double.infinity,//max width
                                            height: 40,

                                            child: Center(// set text of every button
                                              child: Text(_exercises[i]['exercises'][j]['name'],//name of button generated from JSON database
                                                style: TextStyle(color: Colors.white, fontSize: 15.0),//set color of text
                                                textAlign: TextAlign.center,
                                              ),),
                                          ),
                                        );

                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(//button zrusit
                              child: Text('Zrušit'),//tilte of button
                              onPressed: () {//what to do on pressed
                                Navigator.of(context).pop();//close current alert dialog
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
      ),
    );
  }
}