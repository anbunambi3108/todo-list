import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  EditTask({this.title, this.duedate, this.description, this.index});
  final String title;
  final String description;
  final String duedate;
  final index;
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  TextEditingController controllerTitle;
  TextEditingController controllerDescription;
  TextEditingController controllerDuedate;

  DateTime _dueDate;
  String _dateText = "";

  String newTask;
  String description;

  void _editTask() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentSnapshot snapshot = 
      await transaction.get(widget.index);
      await transaction.update(snapshot.reference,
          {"title": newTask, "description": description, "duedate": _dueDate});
    });
    Navigator.pop(context);
  }

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2120));
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }
//for adding data to firebase:

  @override
  void initState() {
    super.initState();
    _dueDate = widget.duedate as DateTime;
    _dateText = "${_dueDate.day}-${_dueDate.month}-${_dueDate.year}";

    newTask = widget.title;
    description = widget.description;

    controllerTitle = new TextEditingController(text: widget.title);
    controllerDescription = new TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("Assets/purpbg.jpg"), fit: BoxFit.cover),
                color: Colors.deepPurple[50]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "My tasks",
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "Edit task",
                      style: new TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.list,
                    color: Colors.white,
                    size: 30.0,
                  )
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: controllerTitle,
              onChanged: (String str) {
                setState(() {
                  newTask = str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.assignment),
                  hintText: "Add Task",
                  border: InputBorder.none),
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.date_range),
                ),
                Expanded(
                    child: Text(
                  "Due date :",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                )),
                FlatButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text(
                      _dateText,
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
                controller: controllerDescription,
                onChanged: (String str) {
                  setState(() {
                    description = str;
                  });
                },
                decoration: new InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: "Description",
                    border: InputBorder.none)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        size: 27,
                      ),
                      onPressed: () {
                        _editTask();
                      }),
                  // IconButton(icon:Icon(Icons.star_border ,size:27,),
                  //  onPressed: (){}
                  //  ),
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 27,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ]),
          )
        ],
      ),
    );
  }
}


