import 'package:flutter/material.dart';

void main() {
  runApp(const TaskListApp());
}

class TaskListApp extends StatelessWidget {
  const TaskListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Colors.black87),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<String> tasks = ['Task 1', 'Task 2', 'Task 3']; // Example tasks
  List<bool> taskCompletion = [false, false, false]; // Tracks completion status

  final TextEditingController _taskEditingController = TextEditingController();
  late int _editIndex;

  @override
  void dispose() {
    _taskEditingController.dispose();
    super.dispose();
  }

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
      taskCompletion.add(false);
      print('Task Added: $task'); // Track user interaction
    });
  }

  void _editTask(int index, String newTask) {
    setState(() {
      tasks[index] = newTask;
      print('Task Edited: $newTask'); // Track user interaction
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      taskCompletion.removeAt(index);
      print('Task Deleted'); // Track user interaction
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: ListTile(
              title: Text(
                tasks[index],
                style: TextStyle(
                  fontSize: 18.0,
                  color: taskCompletion[index] ? Colors.grey : Colors.black,
                  decoration: taskCompletion[index]
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              onTap: () {
                setState(() {
                  taskCompletion[index] = !taskCompletion[index];
                  print('Task ${tasks[index]} is ${taskCompletion[index] ? 'completed' : 'uncompleted'}'); // Track task completion
                });
              },
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Task"),
                      content: const Text("Are you sure you want to delete this task?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            _deleteTask(index);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    _editIndex = index;
                    _taskEditingController.text = tasks[index];
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Edit Task"),
                        content: TextField(
                          controller: _taskEditingController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            labelText: 'Task',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              _editTask(_editIndex, _taskEditingController.text);
                              Navigator.of(context).pop();
                            },
                            child: const Text("Save"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Add Task"),
                content: TextField(
                  controller: _taskEditingController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Task',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      _addTask(_taskEditingController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
