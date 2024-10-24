import 'package:flutter/material.dart';
import 'package:garments_inventory/services/database_service.dart';
import 'package:garments_inventory/model/user_model.dart';
import 'package:garments_inventory/screens/dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  final DatabaseService _databaseService = DatabaseService();

  // Function to handle login
  Future<void> _login() async {
    String userId = _userIdController.text;
    String password = _passwordController.text;

    try {
      // Fetch the user from Firestore using custom user ID
      User? user = await _databaseService.getUserByUserId(userId);

      if (user != null) {
        // Decrypt the password for comparison
        String decryptedPassword =
            User.decryptPassword(user.password, _databaseService.encryptionKey);
        if (decryptedPassword == password) {
          print("User authenticated: ${user.userId}, Admin: ${user.isAdmin}");
          setState(() {
            _errorMessage = null;
          });

          // Redirect to Dashboard, pass the isAdmin flag
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(isAdmin: user.isAdmin)),
          );
        } else {
          setState(() {
            _errorMessage = 'Incorrect password';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'User not found';
        });
      }
    } catch (e) {
      print("Login failed with error: $e");
      setState(() {
        _errorMessage = 'Login failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // User ID Input
              TextField(
                controller: _userIdController,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Password Input
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Login Button
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
