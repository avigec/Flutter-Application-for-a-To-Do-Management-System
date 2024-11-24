import 'package:flutter/material.dart';
import 'package:to_do/screens/add_page.dart';
import 'package:to_do/services/todo_service.dart';
import 'package:to_do/utils/snackbar_helper.dart';
import 'package:to_do/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  String filter = "All"; // Filter option: All, Completed, Pending

  @override
  void initState() {
    //for rendering and displaying Statefull widgets
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    List filteredItems = items.where((item) {
      if (filter == "Completed") return item['is_completed'] == true;
      if (filter == "Pending") return item['is_completed'] == false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "All", child: Text("All")),
              const PopupMenuItem(value: "Completed", child: Text("Completed")),
              const PopupMenuItem(value: "Pending", child: Text("Pending")),
            ],
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchTodo,
        child: filteredItems.isEmpty
            ? const Center(child: Text('No Tasks Found'))
            : ListView.builder(
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return TodoCard(
              index: index,
              item: item,
              navigateEdit: navigateToEditPage,
              deleteById: deleteById,
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: navigateToAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, message: 'Failed to fetch tasks');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    // setState(() {
    //   //for automatically Updating task without refreshing
    //   isLoading = true;
    // });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    // setState(() {
    //   //for automatically adding new task without refreshing
    //   isLoading = true;
    // });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //show error
      showErrorMessage(context, message: 'Failed to delete task');
    }
  }

  // Future<void> fetchTodo() async {
  //   //for getting the data from submitted todo events
  //   final response = await TodoService.fetchTodo();
  //
  //   if (response != null) {
  //     setState(() {
  //       items = response;
  //     });
  //   } else {
  //     showErrorMessage(context, message: 'Something Went Wrong');
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
}
