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

//////////////////////////////////////
  Future<void> saveSelectedExercisesToJson(String dayOfWeek, List<Map<String, dynamic>> selectedExercises) async {//function save selected exrcises to the file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$dayOfWeek.json');
    final jsonData = jsonEncode(_selectedExercises);
    await file.writeAsString(jsonData);
  }

//////////////////////////////////////
  Future<List<Map<String, dynamic>>> loadSelectedExercisesFromJson(String dayOfWeek) async {//function to load selected exercises for certain day
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$dayOfWeek.json');
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final selectedExercises = List<Map<String, dynamic>>.from(jsonDecode(jsonData));
      return _selectedExercises = selectedExercises;
    } else {
      return [];
    }
  }


//////////////////////////////////////
  Future<String> _loadExerciseAsset() async { //loading of main exercise database
    return await rootBundle.loadString('assets/cviky.json');
  }


//////////////////////////////////////
  Future<List<dynamic>> _getExercises() async { //getting of exercises from previous loading function
    String jsonString = await _loadExerciseAsset();
    List<dynamic> exercises = jsonDecode(jsonString);
    return exercises;
  }

  //////////////////////////////////
  Future<void> _createJsonFiles() async { //function to create files, when is app launched
    final directory = await getApplicationDocumentsDirectory();
    for (int weekday = DateTime.monday; weekday <= DateTime.sunday; weekday++) {
      final file = File('${directory.path}/${_getDayOfWeek(weekday)}.json');
      if (!(await file.exists())) {
        for (int i = DateTime.monday; i <= DateTime.sunday; i++) {
          String dayOfWeek = _getDayOfWeek(i);
          saveSelectedExercisesToJson(dayOfWeek, []);
        }
      }
    }
  }


  @override
  void initState() {//when is app launched make this
    super.initState();
    _getExercises().then((exercises) {
      setState(() {
        _exercises = exercises;
      });
    });
    _createJsonFiles();//create json files when is app launched
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
        actions: [
          IconButton(//exit button
            icon: Icon(Icons.exit_to_app),//icon of exit button
            onPressed: () => exit(0),//exit the app on pressed
          ),
        ],
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
                  onPressed: () async {//what to do on pressed of icon
                    Navigator.of(context).push(//navigate to new screen
                      MaterialPageRoute(//
                        builder: (BuildContext context) {

                          return SavedExercises(//new screen -widget - file training.dart
                            dayOfWeek: _getDayOfWeek(index+ 1),//required data to the new screen - widget file training.dart
                            selectedExercises: _selectedExercises,//required data to the new screen - list od selected exercises
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
                    // _selectedExercises.clear();// this is was added due problem with adding exercises to certain day, now this list is cleaned after click on every add icon

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
                                        loadSelectedExercisesFromJson(_getDayOfWeek(index + 1));
                                        return TextButton(// every exercise is button
                                          onPressed: () {// set what to do on pressed

                                            setState(() => {

                                              _selectedExercises.add({//on pressed add exercise to the list with selected exercises
                                                'name': _exercises[i]['exercises'][j]['name'],
                                                'repetition': _exercises[i]['exercises'][j]['repetition'],
                                                'time': _exercises[i]['exercises'][j]['time'],
                                                'series': _exercises[i]['exercises'][j]['series'],
                                              }),


                                            });
                                            saveSelectedExercisesToJson(_getDayOfWeek(index+1), _selectedExercises);//call function save selected exercise to the certain file
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