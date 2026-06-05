import 'package:flutter/material.dart';
import '../services/task_service.dart';
import 'add_edit_task_screen.dart';
import 'task_detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TaskService taskService = TaskService();
  late Future<List<dynamic>> tasksFuture;
  List<dynamic> allTasks = [];
  List<dynamic> filteredTasks = [];
  String selectedStatus = "All";
  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "In Progress":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    print("Refreshing Tasks...");

    final tasks = await taskService.getTasks();

    setState(() {
      allTasks = tasks;
      filteredTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await loadTasks();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTaskScreen()),
          );

          if (result == true) {
            await loadTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search Task",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  filteredTasks = allTasks.where((task) {
                    return task["title"].toString().toLowerCase().contains(
                      value.toLowerCase(),
                    );
                  }).toList();
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: "Filter By Status",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "All", child: Text("All")),
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(
                  value: "In Progress",
                  child: Text("In Progress"),
                ),
                DropdownMenuItem(value: "Completed", child: Text("Completed")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;

                  if (selectedStatus == "All") {
                    filteredTasks = allTasks;
                  } else {
                    filteredTasks = allTasks.where((task) {
                      return task["status"] == selectedStatus;
                    }).toList();
                  }
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: loadTasks,
              child: filteredTasks.isEmpty
                  ? const Center(child: Text("No Tasks Found"))
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];

                        return InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(task: task),
                              ),
                            );

                            if (result == true) {
                              await loadTasks();
                            }
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(task["title"]),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(task["description"]),
                                  const SizedBox(height: 4),
                                  Chip(
                                    label: Text(
                                      task["status"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: getStatusColor(
                                      task["status"],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Chip(
                                label: Text(task["priority"]),
                                backgroundColor: getPriorityColor(
                                  task["priority"],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
