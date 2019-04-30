import 'package:flutter/material.dart';
import 'package:note_keeper/models/Note.dart';
import 'package:note_keeper/screens/add_or_edit_note.dart';
import 'package:note_keeper/screens/note_list.dart';

class RouteGenerator {
  static MaterialPageRoute<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => NoteList());
      case '/second':
        if (args is Data) {
          if (args.data is Note) {
            return MaterialPageRoute<bool>(
                builder: (_) => AddOrEditNote(
                      args.appBarTitle,
                      args.data,
                    ));
          }
        }
    }
    return null;
  }
}
