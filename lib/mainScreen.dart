import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/addTodo.dart';
import 'package:todoapp/widgets/todoList.dart';
import 'package:url_launcher/url_launcher.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<String> todoList = [];
  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: const Text("Already exists"),
          content: const Text("This todo data already exists."),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            )
          ],
        );
      });

      return;
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    updateLocalData();
    Navigator.pop(context);
  }

  void updateLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    todoList = (prefs.getStringList("todoList") ?? []).toList();
    setState(() {

    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void showAddTodoBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 200,
              child: AddTodo(addTodo: addTodo),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blueGrey[900],
        child: Icon(Icons.add, color: Colors.white),
        onPressed: showAddTodoBottomSheet,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Colors.blueGrey[900],
              height: 200,
              width: double.infinity,
              child: Center(
                child: Text(
                  "Todo App",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://github.com/NgnDinhThanh"));
              },
              leading: Icon(Icons.person),
              title: Text("About Me",
              style: TextStyle(fontWeight: FontWeight.bold))
            ),
            ListTile(
                onTap: () {
                  launchUrl(Uri.parse("mailto: someone@gmail.com"));
                },
                leading: Icon(Icons.email),
                title: Text("Contact me",
                    style: TextStyle(fontWeight: FontWeight.bold))
            )
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Todo App"),
      ),
      body: TodoListBuilder(todoList: todoList, updateLocalData: updateLocalData),
    );
  }
}
