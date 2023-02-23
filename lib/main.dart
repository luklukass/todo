import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:training_planner_v1/page/home.dart';
import 'package:training_planner_v1/page/training.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tréninkový plánovač',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/training': (context) => SavedExercises(dayOfWeek: '',),

      },
      initialRoute: '/',
    );
  }
}
