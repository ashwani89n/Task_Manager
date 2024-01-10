import 'package:flutter/material.dart';

class SubTask {
  String subtaskname;
  bool isCompleted;
  SubTask(this.subtaskname, this.isCompleted);
}

class Task {
  String name;
  bool isCompleted;
  List<SubTask> subTasks;
  Task(this.name, this.isCompleted, {List<SubTask>? subTasks})
      : subTasks = subTasks ?? <SubTask>[];
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];

  String newTaskName = '';
  String newSubTaskName = '';

  void addTask() {
    if (newTaskName.isNotEmpty) {
      setState(() {
        tasks.add(Task(newTaskName, false));
      });
    } else {
      newTaskName = ' ';
    }
  }

  void toggleTaskCompletionTask(int taskIndex) {
    setState(() {
      tasks[taskIndex].isCompleted = !tasks[taskIndex].isCompleted;
      if (!tasks[taskIndex].isCompleted) {
        uncheckAllSubtasks(taskIndex);
      }
      _showWarningDialog(context, 'This Task is Completed!');
    });
  }

  void uncheckAllSubtasks(int taskIndex) {
    setState(() {
      tasks[taskIndex].subTasks.forEach((subTask) {
        subTask.isCompleted = false;
      });
    });
  }

  void toggleTaskCompletionSubTask(int taskIndex, int subTaskIndex) {
    setState(() {
      tasks[taskIndex].subTasks[subTaskIndex].isCompleted =
          !tasks[taskIndex].subTasks[subTaskIndex].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void deleteSubTask(int index, int subtaskIndex) {
    setState(() {
      tasks[index].subTasks.removeAt(subtaskIndex);
    });
  }

  void addSubTask(int taskIndex, String subTaskName) {
    if (!tasks[taskIndex].isCompleted) {
      setState(() {
        tasks[taskIndex].subTasks.add(SubTask(subTaskName, false));
      });
    }
  }

  void _showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Task Name',
              ),
              onChanged: (value) {
                setState(() {
                  newTaskName = value;
                });
              },
              onSubmitted: (taskName) {
                addTask();
              },
            ),
          ),
          ElevatedButton(
            onPressed: addTask,
            child: const Text('Add Task'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, taskIndex) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Checkbox(
                          value: tasks[taskIndex].isCompleted,
                          onChanged: (value) {
                            toggleTaskCompletionTask(taskIndex);
                          },
                        ),
                        title: Text(tasks[taskIndex].name),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(taskIndex);
                          },
                        ),
                      ),
                      const Text('SubTasks'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: tasks[taskIndex].subTasks.length,
                        itemBuilder: (context, subTaskIndex) {
                          return ListTile(
                            leading: Checkbox(
                              value: tasks[taskIndex]
                                  .subTasks[subTaskIndex]
                                  .isCompleted,
                              onChanged: (value) {
                                toggleTaskCompletionSubTask(
                                    taskIndex, subTaskIndex);
                                _showWarningDialog(
                                    context, 'This Subtask is Completed!');
                              },
                            ),
                            title: Text(tasks[taskIndex]
                                .subTasks[subTaskIndex]
                                .subtaskname),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                deleteSubTask(taskIndex, subTaskIndex);
                              },
                            ),
                          );
                        },
                      ),
                      if (!tasks[taskIndex].isCompleted) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Subtask Name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                newSubTaskName = value;
                              });
                            },
                            onSubmitted: (subTaskName) {
                              addSubTask(taskIndex, subTaskName);
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
