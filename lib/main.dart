import 'package:flutter/material.dart';

void main() => runApp(NoteKeeper());

class NoteKeeper extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Keeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteKeeperHomePage(),
    );
  }
}

class NoteKeeperHomePage extends StatefulWidget {

  @override
  _NoteKeeperHomePageState createState() => _NoteKeeperHomePageState();
}

class _NoteKeeperHomePageState extends State<NoteKeeperHomePage> {

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
    );
  }
}
