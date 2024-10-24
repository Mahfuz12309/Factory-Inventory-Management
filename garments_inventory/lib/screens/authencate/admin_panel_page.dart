import 'package:flutter/material.dart';
import 'package:garments_inventory/services/database_service.dart';
import 'package:garments_inventory/model/user_model.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();
  List<User> _users = [];

  String _selectedRole = 'User'; // Default role
  String currentAdminId = 'admin'; // ID of the currently logged-in admin

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Fetch users when the page is initialized
  }

  Future<void> _fetchUsers() async {
    List<User> users = await _databaseService.getAllUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _createUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      User newUser = User(
        id: '', // Firestore will generate the ID
        userId: username,
        password: password,
        isAdmin: _selectedRole == 'Admin', // Set role based on selection
      );

      await _databaseService.createUser(newUser);
      _usernameController.clear();
      _passwordController.clear();
      _selectedRole = 'User'; // Reset to default
      _fetchUsers(); // Refresh the user list

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out both fields')),
      );
    }
  }

  Future<void> _deleteUser(String userId) async {
    // Check if the user being deleted is the currently logged-in admin
    if (userId == currentAdminId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete the admin user.')),
      );
      return; // Exit the function if trying to delete the admin
    }

    await _databaseService.deleteUser(userId);
    _fetchUsers(); // Refresh the user list after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User deleted successfully')),
    );
  }

  Future<void> _updateUserRole(User user, String newRole) async {
    // Update the user's role in the database
    user.isAdmin = newRole == 'Admin';
    await _databaseService.updateUser(user); // Ensure you have this method in your DatabaseService
    _fetchUsers(); // Refresh the user list after updating
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User role updated to $newRole successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel - Manage Users'),
      ),
      body: Center( // Center the entire body
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Make the column size wrap to its children
            children: [
              // Centered Username Input with smaller width
              Container(
                width: 250, // Set a specific width for the text field
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Spacer

              // Centered Password Input with smaller width
              Container(
                width: 250, // Set a specific width for the text field
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: false, // Allow password visibility
                ),
              ),
              const SizedBox(height: 10), // Spacer

              // Centered Role Selection Dropdown with smaller width
              Container(
                width: 250, // Set a specific width for the dropdown
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  isExpanded: true, // Make the dropdown take the full width
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  items: <String>['User', 'Admin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Create User Button
              ElevatedButton(
                onPressed: _createUser,
                child: const Text('Create User'),
              ),
              const SizedBox(height: 16),

              // Users Data Table
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Role')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _users.map((user) {
                      return DataRow(cells: [
                        DataCell(Text(user.userId)),
                        DataCell(
                          // Dropdown for changing user role
                          DropdownButton<String>(
                            value: user.isAdmin ? 'Admin' : 'User',
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                _updateUserRole(user, newValue);
                              }
                            },
                            items: <String>['User', 'Admin']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user.id),
                          ),
                        ),
                      ]);
                    }).toList(),
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
