import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:todo/page/training.dart';

class SavedExercises extends StatelessWidget {
  final String dayOfWeek;

  SavedExercises({required this.dayOfWeek});

  Future<Map<String, dynamic>> _loadSelectedExercises() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final dbFilePath = '${dbDirectory.path}/$dayOfWeek.json';
    final file = File(dbFilePath);

    if (await file.exists()) {
      final String contents = await file.readAsString();
      return json.decode(contents);
    }

    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dayOfWeek),
      ),
      body: FutureBuilder(
        future: _loadSelectedExercises(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> selectedExercises =
                snapshot.data['selectedExercises'] ?? [];

            return ListView.builder(
              itemCount: selectedExercises.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(selectedExercises[index]),
              ),
            );
          } else {
            return Center(
              child: Text('Žádné cviky'),
            );
          }
        },
      ),
    );
  }
}