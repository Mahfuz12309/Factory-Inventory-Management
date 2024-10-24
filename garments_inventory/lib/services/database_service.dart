import 'package:firedart/firedart.dart';
import 'package:garments_inventory/model/user_model.dart';
import 'package:garments_inventory/model/party_model.dart'; // Make sure you have the Party model imported

class DatabaseService {
  final Firestore _firestore = Firestore.instance;
  final String userCollection = 'users'; // The Firestore collection to store users
  final String partyCollection = 'parties'; // The Firestore collection to store parties
  final String encryptionKey =
      'this_is_a_32_characters_long_key!'; // Ensure this key is 32 characters

  // Create a new user in Firestore
  Future<void> createUser(User user) async {
    try {
      // Encrypt the password before saving
      String encryptedPassword = User.encryptPassword(user.password, encryptionKey);
      user.password = encryptedPassword; // Update user object with encrypted password

      await _firestore.collection(userCollection).add(user.toJson());
      print("User created successfully");
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  // Check if any users exist
  Future<bool> usersExist() async {
    try {
      var usersSnapshot = await _firestore.collection(userCollection).get();
      return usersSnapshot.isNotEmpty;
    } catch (e) {
      print("Error checking users: $e");
      return false;
    }
  }

  // Get a user by UserId
  Future<User?> getUserByUserId(String userId) async {
    try {
      var usersSnapshot = await _firestore
          .collection(userCollection)
          .where('userId', isEqualTo: userId)
          .get();
      if (usersSnapshot.isNotEmpty) {
        return User.fromJson(usersSnapshot.first.id, usersSnapshot.first.map);
      }
    } catch (e) {
      print("Error getting user: $e");
    }
    return null; // Return null if not found
  }

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      var usersSnapshot = await _firestore.collection(userCollection).get();
      return usersSnapshot
          .map((doc) => User.fromJson(doc.id, doc.map))
          .toList();
    } catch (e) {
      print("Error getting users: $e");
      return [];
    }
  }

  // Delete a user from the database
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(userCollection).document(userId).delete();
      print("User deleted successfully");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Update user role or information
  Future<void> updateUser(User user) async {
    try {
      await _firestore.collection(userCollection).document(user.id).update({
        'isAdmin': user.isAdmin,
      });
      print('User updated successfully: ${user.userId}');
    } catch (e) {
      print('Failed to update user: $e');
      throw e;
    }
  }

  // Create a new party (buyer/seller)
  Future<void> createParty(Party party) async {
    try {
      await _firestore.collection(partyCollection).add(party.toJson());
      print("Party created successfully");
    } catch (e) {
      print("Error creating party: $e");
    }
  }

  // Get all parties (buyer/seller)
  Future<List<Party>> getAllParties() async {
    try {
      var partySnapshot = await _firestore.collection(partyCollection).get();
      return partySnapshot.map((doc) => Party.fromJson(doc.id, doc.map)).toList();
    } catch (e) {
      print("Error getting parties: $e");
      return [];
    }
  }

  // Delete a party (admin-only)
  Future<void> deleteParty(String partyId) async {
    try {
      await _firestore.collection(partyCollection).document(partyId).delete();
      print("Party deleted successfully");
    } catch (e) {
      print("Error deleting party: $e");
    }
  }
}
