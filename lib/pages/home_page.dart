import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';
import 'package:todo/utilities/dialog_box.dart';
import 'package:todo/utilities/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the first time opening the app then create the default data
    if(_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }else{
      //there already exists a data
      db.loadData();
    }
    super.initState();
  }

  final _controller = TextEditingController();
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text,false]);
      _controller.clear();
      Navigator.pop(context);
    });
    db.updateDataBase();
  }

  void cancelTask(){
    setState(() {
      _controller.clear();
      Navigator.pop(context);
    });
  }

  void buttonOnChanged(bool? value,int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void createNewTask(){
    showDialog(
      context: context,
      builder: (context){
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: cancelTask,
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: const Text(
            'To Do',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context,index){
          return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => buttonOnChanged(value, index),
              deleteFunction: (value) => deleteTask(index),
          );
        },
      ),
    );
  }
}
