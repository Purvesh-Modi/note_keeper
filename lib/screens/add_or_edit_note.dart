import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_keeper/models/Note.dart';
import 'package:note_keeper/utils/database_helper.dart';

class AddOrEditNote extends StatefulWidget {
  final String _title;
  final Note _note;

  AddOrEditNote(this._title, this._note);

  @override
  State<StatefulWidget> createState() => AddOrEditNoteState(_title, _note);
}

class AddOrEditNoteState extends State<AddOrEditNote> {
  final String _appBarTitle;
  final Note _note;

  DataBaseHelper databaseHelper = DataBaseHelper();

  static var _priorities = ['Low', 'High'];
  var _currentSelected = '';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  AddOrEditNoteState(this._appBarTitle, this._note);

  @override
  void initState() {
    super.initState();
    _currentSelected = getPriorityAsString(_note.priority);
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.title;

    titleController.text = _note.title;
    descriptionController.text = _note.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            DropdownButton<String>(
              items: _priorities.map((String dropDownItem) {
                return DropdownMenuItem<String>(
                  value: dropDownItem,
                  child: Text(dropDownItem),
                );
              }).toList(),
              value: _currentSelected,
              style: textStyle,
              onChanged: (newValueSelected) =>
                  _onDropdownItemSelected(newValueSelected),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (title) => _onTitleChanged(title),
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: descriptionController,
                style: textStyle,
                onChanged: (description) => _onDescriptionChanged(description),
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      "Save",
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () => _onSaveButtonClicked(),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      "Delete",
                      textScaleFactor: 1.5,
                    ),
                    onPressed: () => _onDeleteButtonClicked(),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDropdownItemSelected(String newValueSelected) {
    updatePriorityAsInt(newValueSelected);
    setState(() {
      _currentSelected = newValueSelected;
    });
  }

  void _onTitleChanged(String title) {
    _note.title = title;
  }

  void _onDescriptionChanged(String description) {
    _note.description = description;
  }

  void _onSaveButtonClicked() async {
    _note.createdOn = DateFormat.yMMMd().format(DateTime.now());
    var result;
    if (_note.id != null) {
      result = await databaseHelper.updateNote(_note);
    } else {
      result = await databaseHelper.insetNote(_note);
    }

    if (result != 0) {
      navigateToLastScreen(true); //Success
    } else {
      navigateToLastScreen(true); //Failure
    }
  }

  void _onDeleteButtonClicked() async {
    var result;
    if (_note.id != null) {
      result = await databaseHelper.deleteNote(_note);
    }

    if (result != 0) {
      navigateToLastScreen(true);
    } else {
      navigateToLastScreen(true);
    }
  }

  void updatePriorityAsInt(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        _note.priority = 1;
        break;
      case 'high':
        _note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) => _priorities[value - 1];

  void navigateToLastScreen(bool result) {
    Navigator.pop(context, result);
  }
}
