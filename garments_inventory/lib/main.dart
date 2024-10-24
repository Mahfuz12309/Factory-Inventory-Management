// main.dart
import 'package:flutter/material.dart';
import 'package:firedart/firedart.dart';
import 'package:garments_inventory/services/database_service.dart';
import 'package:garments_inventory/model/user_model.dart';
import 'package:garments_inventory/screens/authencate/login.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized

  // Initialize Firebase with the API Key and Project ID
  Firestore.initialize('garments-inventory'); // Add your Firebase Project ID
  windowManager.setMinimumSize(Size(800, 600)); // Set your desired minimum size

  // Create the first user if none exists
  await createFirstUser();

  runApp(MyApp());
}

Future<void> createFirstUser() async {
  DatabaseService databaseService = DatabaseService();

  // Check if any users exist
  bool exists = await databaseService.usersExist();
  if (!exists) {
    // Create a default admin user
    User firstUser = User(
      id: '1', // You can use any string as the ID; Firestore will handle it
      userId: 'admin', // This will be the user ID
      password: 'admin123', // Use a default password
      isAdmin: true, // Mark as admin
    );

    await databaseService.createUser(firstUser); // Create the first user
    print("First user created: ${firstUser.userId}");
  } else {
    print("User already exists in the database.");
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factory Inventory Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
