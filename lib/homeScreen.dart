import 'package:flutter/material.dart';
import 'package:my_life_resume/eventScreen.dart';

class HomeScreen extends StatelessWidget {
 // const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EventScreen(),
    );
  }
}
