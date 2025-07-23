import 'package:flutter/material.dart';
import 'api_service.dart';
import 'todo_model.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

extension ColorExtension on Color {
  Color withOpacityDouble(double opacity) {
    return withAlpha((opacity * 255).round());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  void _fetchTodos() async {
    try {
      final todos = await _apiService.getTodos();
      setState(() {
        _todos = todos;
      });
    } catch (e) {
      _showError('Failed to load todos');
    }
  }

  void _addTodo(String title) async {
    try {
      final newTodo = await _apiService.createTodo(
        Todo(id: 0, title: title, completed: false),
      );
      setState(() {
        _todos.add(newTodo);
        _controller.clear();
      });
    } catch (e) {
      _showError('Failed to add todo');
    }
  }

  void _deleteTodo(int id) async {
    try {
      await _apiService.deleteTodo(id);
      setState(() {
        _todos.removeWhere((todo) => todo.id == id);
      });
    } catch (e) {
      _showError('Failed to delete todo');
    }
  }

  void _toggleCompleted(Todo todo) async {
    try {
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        completed: !todo.completed,
      );
      final newTodo = await _apiService.updateTodo(updatedTodo);
      setState(() {
        final index = _todos.indexWhere((t) => t.id == newTodo.id);
        if (index != -1) {
          _todos[index] = newTodo;
        }
      });
    } catch (e) {
      _showError('Failed to update todo');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = _todos.where((todo) => todo.completed).length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(160, 71, 172, 4),
              Color.fromARGB(255, 45, 215, 253),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'To-Do App',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$completedCount of ${_todos.length} tasks completed',
                style: const TextStyle(
                  color: Color.fromARGB(221, 235, 230, 230),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'What needs to be done?',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) _addTodo(value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacityDouble(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            _addTodo(_controller.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Checkbox(
                            value: todo.completed,
                            onChanged: (value) {
                              _toggleCompleted(todo);
                            },
                          ),
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration: todo.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('dd/MM/yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 224, 222, 222),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(todo.id!),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
