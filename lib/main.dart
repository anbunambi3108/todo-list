import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos/AddTask.dart';

import 'editData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new todo(),
    );
  }
}

class todo extends StatefulWidget {
  @override 
  _todoState createState() => new _todoState();
}

class _todoState extends State<todo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new AddTask()));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurple[200],
          shape: _DiamondBorder(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
            elevation: 50.0,
            color: Colors.deepPurple,
            child: ButtonBar(
              children: <Widget>[],
            )),
        body: Stack(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 160),
            child: StreamBuilder(
              stream: Firestore.instance.collection("todos").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                return new TaskList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("Assets/purpbg.jpg"), fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(color: Colors.deepPurple, blurRadius: 8.0)
                ],
                color: Colors.deepPurple),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "My Tasks",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontFamily: "Amatic_SC"),
                  ),
                ]),
          ),
        ]));
  }
}

//diamond shaped add icon bottom centre:
class _DiamondBorder extends ShapeBorder {
  const _DiamondBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..lineTo(rect.right, rect.top + rect.height / 2.0)
      ..lineTo(rect.left + rect.width / 2.0, rect.bottom)
      ..lineTo(rect.left, rect.top + rect.height / 2.0)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  // This border doesn't support scaling.
  @override
  ShapeBorder scale(double t) {
    return null;
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i) {
        String Title = document[i].data['Title'].toString();
        String Description = document[i].data['Description'].toString();
        DateTime _date = document[i].data['Due date'];
        String dueDate = "${_date.day}-${_date.month}-${_date.year}";

        return Dismissible(
          key: new Key(document[i].documentID),
          onDismissed: (direction) {
            Firestore.instance.runTransaction((transaction) async {
              DocumentSnapshot snapshot =
                  await transaction.get(document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text("Task deleted"),
            ));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            Title,
                            style: new TextStyle(
                              fontSize:20.0,
                              letterSpacing: 1.0
                            ),
                          ),
                        ), //task
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.description, //description of task
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              Description,
                              style: new TextStyle(
                                fontSize: 17,
                              ),
                            ), //description of task
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.date_range, //due date of task
                                color: Colors.black,
                              ),
                            ),
                            Expanded(
                                child: Text(
                              dueDate,
                              style: new TextStyle(
                                fontSize: 16,
                              ),
                            )), //due date of task
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                new IconButton(
                  //to edit the existing data
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => new EditTask(
                              title: Title,
                              description: Description,
                              duedate: document[i].data["duedata"],
                              index: document[i].reference,
                            )));
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
