import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirebaseAuth.instance.currentUser == null ? LoginPage() : TaskListScreen(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TaskListScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Task Management',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _login(context),
                child: Text('Login', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SignupPage()));
                },
                child: Text(
                  'Don’t have an account? Sign up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TaskListScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'Task Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _signup(context),
              child: Text('Sign Up', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference _tasksCollection = FirebaseFirestore.instance.collection('tasks');
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  String _selectedDay = 'Monday';
  final List<String> _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  String _selectedTime = '9 am - 10 am';
  final List<String> _timeFrames = [
    '9 am - 10 am',
    '10 am - 11 am',
    '11 am - 12 pm',
    '12 pm - 1 pm',
    '1 pm - 2 pm',
    '2 pm - 3 pm',
    '4 pm - 5 pm',
    '6 pm - 7 pm',
  ];

  void _addTask(String taskName) {
    if (taskName.isNotEmpty) {
      _tasksCollection.add({
        'name': taskName,
        'isCompleted': false,
        'day': _selectedDay,
        'hour': _selectedTime,
        'userId': _currentUser?.uid,
      });
      _taskController.clear();
    }
  }

  void _toggleTaskCompletion(DocumentSnapshot task) {
    _tasksCollection.doc(task.id).update({'isCompleted': !task['isCompleted']});
  }

  void _deleteTask(String taskId) {
    _tasksCollection.doc(taskId).delete();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          TextButton(
            onPressed: _logout,
            child: Text('Logout', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Task Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: _selectedDay,
                      items: _daysOfWeek.map((day) {
                        return DropdownMenuItem(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDay = value!;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: _selectedTime,
                      items: _timeFrames.map((time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTime = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _taskController,
                        decoration: InputDecoration(labelText: 'Enter Task Name'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _addTask(_taskController.text),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasksCollection.where('userId', isEqualTo: _currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                Map<String, Map<String, List<QueryDocumentSnapshot>>> tasksByDayAndTime = {};
                snapshot.data!.docs.forEach((task) {
                  final day = task['day'];
                  final hour = task['hour'];
                  if (!tasksByDayAndTime.containsKey(day)) {
                    tasksByDayAndTime[day] = {};
                  }
                  if (!tasksByDayAndTime[day]!.containsKey(hour)) {
                    tasksByDayAndTime[day]![hour] = [];
                  }
                  tasksByDayAndTime[day]![hour]!.add(task);
                });

                return ListView(
                  children: tasksByDayAndTime.entries.map((dayEntry) {
                    String day = dayEntry.key;
                    Map<String, List<QueryDocumentSnapshot>> timeFrames = dayEntry.value;

                    return ExpansionTile(
                      title: Text(day),
                      children: timeFrames.entries.map((timeEntry) {
                        String timeFrame = timeEntry.key;
                        List<QueryDocumentSnapshot> tasks = timeEntry.value;

                        return ExpansionTile(
                          title: Text(timeFrame),
                          children: tasks.map((task) {
                            return ListTile(
                              title: Text(
                                task['name'],
                                style: TextStyle(
                                  decoration: task['isCompleted']
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              leading: Checkbox(
                                value: task['isCompleted'],
                                onChanged: (_) => _toggleTaskCompletion(task),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _deleteTask(task.id),
                              ),
                            );
                          }).toList(),
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            _currentUser?.email ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}
