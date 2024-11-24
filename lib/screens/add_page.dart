import 'package:flutter/material.dart';
import 'package:to_do/services/todo_service.dart';
import 'package:to_do/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo, //for making add page behave like update page
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  //In order to get the data in the variable(title/description) we use text editing controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title']; //for prefilled edit form
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
      isCompleted = todo['is_completed'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          if (isEdit)
            Row(
              children: [
                const Text("Mark as Completed"),
                Switch(
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
              ),
            ),
          )
        ],
      ),
    );
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": isCompleted,
    };
  }

  Future<void> updateData() async {
    //Get the data from form
    final todo = widget.todo;
    if (todo == null) {
      print('You can not cll update without todo data');
      return;
    }
    final id = todo['_id'];

    //Submit updated data to the Server
    final isSuccess = await TodoService.updateTodo(id, body);
    //Show Status through message either submitted or not
    if (isSuccess) {
      showSuccessMessage(context, message: 'Task Updated');
    } else {
      showErrorMessage(context, message: 'Updation Failed');
    }
  }

  Future<void> submitData() async {
    //Submit data to the Server
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final isSuccess = await TodoService.addTodo(body);

    //Show Status through message either submitted or not
    if (isSuccess) {
      titleController.text = ''; //For restart after submission
      descriptionController.text = ''; //So new data can be added
      showSuccessMessage(context, message: 'Task Added');
    } else {
      showErrorMessage(context, message: 'Task Addition Failed');
    }
  }

  // Map get body {
  //   //Get the data from form
  //   final title = titleController.text;
  //   final description = descriptionController.text;
  //   return {
  //     "title": title,
  //     "description": description,
  //     "is_completed": false,
  //   };
  // }
}
