/*
Lichnovsky Lukas

Feb 2023

KMI/XPROJ

This file is to create Home page
*/

import 'package:flutter/material.dart';
import 'days.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: TrainingPlanner(),
      ),
    );
  }
}
