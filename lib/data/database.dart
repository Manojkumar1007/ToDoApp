import 'package:hive_flutter/adapters.dart';

class ToDoDataBase {
  List toDoList = [];

  //reference your box
  final _myBox = Hive.box('mybox');

  //run this method if this is the first time ever opening this app
  void createInitialData(){
    toDoList = [
      ["Complete the Project", false],
      ["Do exercise", false]
    ];
  }

  //load the data from database
  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  //update the database
  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }

}