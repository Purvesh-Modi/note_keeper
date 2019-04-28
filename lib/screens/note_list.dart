import 'package:flutter/material.dart';
import 'package:note_keeper/models/Note.dart';
import 'package:note_keeper/screens/add_or_edit_note.dart';
import 'package:note_keeper/utils/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteList extends StatefulWidget {
  @override
  State<NoteList> createState() => NoteListState();
}

class NoteListState extends State<NoteList> {
  DataBaseHelper databaseHelper = DataBaseHelper();
  List<Note> noteList;
  var _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List();
      _getUpdatedNotes();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: getNotesAsListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddOrEditNote('Add Note', Note(1, '', '')),
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getNotesAsListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: _itemCount,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(noteList[position].priority),
              child: getPriorityIcon(noteList[position].priority),
            ),
            title: Text(
              noteList[position].title,
              style: titleStyle,
            ),
            subtitle: Text(noteList[position].createdOn),
            trailing: GestureDetector(
              onTap: () => _deleteNote(context, noteList[position]),
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            onTap: () => _navigateToAddOrEditNote('Edit Note', noteList[position]),
          ),
        );
      },
    );
  }

  void _navigateToAddOrEditNote(String title, Note note) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddOrEditNote(title, note),
      ),
    );

    if(result){
      _getUpdatedNotes();
    }else{
      return;
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority - 1) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.red;
    }
    return Colors.green;
  }

  Icon getPriorityIcon(int priority) {
    switch (priority - 1) {
      case 0:
        return Icon(Icons.keyboard_arrow_right);
      case 1:
        return Icon(Icons.play_arrow);
    }
    return Icon(Icons.keyboard_arrow_right);
  }

  void _deleteNote(BuildContext context, Note note) async{
    int result = await databaseHelper.deleteNote(note);
    if(result != 0){
      _showSnackBar(context, 'Note Deleted Successfully');
      _getUpdatedNotes();
    }
  }

  void _showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _getUpdatedNotes() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteFuture = databaseHelper.getNoteList();
      noteFuture.then((noteList) => _updateNoteList(noteList));
    });
  }

  void _updateNoteList(List<Note> noteList) {
    setState(() {
      this.noteList = noteList;
      this._itemCount = noteList.length;
    });
  }
}
