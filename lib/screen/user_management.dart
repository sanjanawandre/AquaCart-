import 'package:flutter/material.dart';

class UserManagement extends StatefulWidget {
  const UserManagement({super.key});

  @override
  _UserManagementState createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> {
  // Dummy users data
  List<Map<String, dynamic>> users = [
    {'id': 1, 'name': 'John Doe', 'email': 'john@example.com', 'blocked': false},
    {'id': 2, 'name': 'Jane Smith', 'email': 'jane@example.com', 'blocked': true},
    {'id': 3, 'name': 'Alice Lee', 'email': 'alice@example.com', 'blocked': false},
  ];

  void _toggleBlockStatus(int index) {
    setState(() {
      users[index]['blocked'] = !users[index]['blocked'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          users[index]['blocked'] ? "User blocked" : "User unblocked",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(user['name']),
              subtitle: Text(user['email']),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: user['blocked'] ? Colors.red : Colors.green,
                ),
                onPressed: () => _toggleBlockStatus(index),
                child: Text(user['blocked'] ? "Unblock" : "Block"),
              ),
            ),
          );
        },
      ),
    );
  }
}
