class Note {
  int _id;
  int _priority;
  String _title;
  String _description;
  String _createdOn;

  Note(this._priority, this._title, this._createdOn, [this._description]);

  Note.withId(this._id, this._priority, this._title, this._createdOn,
      [this._description]);

  String get createdOn => _createdOn;

  String get description => _description;

  String get title => _title;

  int get priority => _priority;

  int get id => _id;

  set createdOn(String value) {
    _createdOn = value;
  }

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
  }

  set priority(int value) {
    _priority = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['createdOn'] = _createdOn;

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._createdOn = map['createdOn'];
  }
}
