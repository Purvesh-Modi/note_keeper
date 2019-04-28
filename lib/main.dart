import 'package:flutter/material.dart';
import 'package:note_keeper/screens/add_or_edit_note.dart';
import 'package:note_keeper/screens/note_list.dart';

void main() => runApp(NoteKeeper());

class NoteKeeper extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Keeper',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: NoteList(),
    );
  }
}
