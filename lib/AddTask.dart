import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  AddTask([Type myApp]);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _dueDate = new DateTime.now();
  String _dateText = "";

  String newTask = '';
  String description = ' ';

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

//for adding data to firebase:

    void _addData() {
      Firestore.instance.runTransaction((Transaction transsaction) async {
        CollectionReference reference =Firestore.instance.collection('todos'); //document name
        await reference.add({
          "Title": newTask,
          "Due date": _dueDate,
          "Description": description,
        });
      });
      Navigator.pop(context);
    }

    @override
    void initState() {
      super.initState();
      _dateText = "${_dueDate.day}-${_dueDate.month}-${_dueDate.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
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
                      fontSize: 30.0,fontFamily: "Amatic_SC"
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("Add today's task",style: new TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      letterSpacing: 2.0,
                      fontFamily: "Amatic_SC")
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
            padding: const EdgeInsets.all(16.0),
            child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.date_range),
                ),
                Expanded(
                    child: Text("Due date :",style: TextStyle(fontSize: 22.0, color: Colors.black54),
                )),
                FlatButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text(_dateText, style: TextStyle(fontSize: 22.0, color: Colors.black54),
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.check,
                        size: 27,
                      ),
                      onPressed: () {
                        // _addData();
                        Navigator.pop(context);
                      }),
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

class _addData {}
