// вариант 1
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Лабораторная работа - Аюшиева В.А.'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          Container(
            width: 100,
            height: 100,
            color: Colors.red, 
            margin: EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.orange, 
            margin: EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '2',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.yellow, 
            margin: EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.green,
            margin: EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '4',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.blue, 
            margin: EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            color: Colors.purple, 
            margin: EdgeInsets.all(4.0),
            child: Center(
              child: Text(
                '6',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}