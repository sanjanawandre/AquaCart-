import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  List users = [];
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchUsers();
  }

  Future<void> _loadTokenAndFetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final data = await ApiService.getUsers(token);
      setState(() => users = data);
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> _deleteUser(int id) async {
    final result = await ApiService.deleteUser(token, id);
    if (result['success'] == true) _fetchUsers();
  }

  Future<void> _approveUser(int id) async {
    // Assuming backend has an approve endpoint
    final result = await ApiService.editUserStatus(token, id, "approved");
    if (result['success'] == true) _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return users.isEmpty
        ? Center(child: Text("No users"))
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final u = users[index];
              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(u['email']),
                  subtitle: Text("Role: ${u['role']} | Status: ${u['status'] ?? 'pending'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (u['status'] != 'approved')
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.green),
                          onPressed: () => _approveUser(u['id']),
                        ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(u['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
