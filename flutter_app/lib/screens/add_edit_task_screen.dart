import 'package:flutter/material.dart';
import '../services/task_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Map? task;

  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String priority = "Medium";
  String status = "Pending";
  DateTime? selectedDate;

  final taskService = TaskService();
  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      titleController.text = widget.task!["title"];
      descriptionController.text = widget.task!["description"];

      priority = widget.task!["priority"];
      status = widget.task!["status"];

      if (widget.task!["due_date"] != null) {
        selectedDate = DateTime.parse(widget.task!["due_date"]);
      }
    }
  }

  Future<void> pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? "Add Task" : "Edit Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),

            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),

            const SizedBox(height: 15),

            DropdownButton<String>(
              value: priority,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Low", child: Text("Low")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "High", child: Text("High")),
              ],
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),
            const SizedBox(height: 15),

            DropdownButton<String>(
              value: status,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(
                  value: "In Progress",
                  child: Text("In Progress"),
                ),
                DropdownMenuItem(value: "Completed", child: Text("Completed")),
              ],
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? "Select Due Date"
                    : "${selectedDate!.day.toString().padLeft(2, '0')}-"
                          "${selectedDate!.month.toString().padLeft(2, '0')}-"
                          "${selectedDate!.year}",
              ),
            ),

            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                final taskData = {
                  "title": titleController.text,
                  "description": descriptionController.text,
                  "priority": priority,
                  "due_date":
                      selectedDate?.toIso8601String().split("T")[0] ??
                      DateTime.now().toIso8601String().split("T")[0],
                  "status": status,
                  "user_id": 1,
                };

                if (widget.task == null) {
                  await taskService.createTask(taskData);
                } else {
                  await taskService.updateTask(widget.task!["id"], taskData);
                }

                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
