import 'package:encrypt/encrypt.dart' as encrypt;

class User {
  String id; // Firestore document ID
  String userId; // Unique identifier for the user
  String password; // Encrypted password
  bool isAdmin; // Flag to check if the user is an admin

  // Constructor
  User({
    required this.id,
    required this.userId,
    required this.password,
    this.isAdmin = false, // Default value for isAdmin
  });

  // Method to encrypt the password before saving to Firestore
  static String encryptPassword(String password, String key) {
    final keyBytes = encrypt.Key.fromUtf8('secretkey:hapilyeverafter1234567');
    final iv = encrypt.IV.fromLength(16); // Randomly generated IV
    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));

    final encrypted = encrypter.encrypt(password, iv: iv);
    return '${iv.base64}:${encrypted.base64}'; // Return IV and encrypted password
  }

  // Method to decrypt the password
  static String decryptPassword(String encryptedPassword, String key) {
    final keyBytes = encrypt.Key.fromUtf8('secretkey:hapilyeverafter1234567');
    final parts = encryptedPassword.split(':'); // Split IV and encrypted password
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase64(parts[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(keyBytes));
    return encrypter.decrypt(encrypted, iv: iv); // Decrypt the password
  }

  // Convert a User object into a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password, // Store encrypted password
      'isAdmin': isAdmin, // Include the isAdmin flag
    };
  }

  // Create a User object from a Firestore document
  static User fromJson(String id, Map<String, dynamic> json) {
    return User(
      id: id,
      userId: json['userId'] ?? '', // Handle null values
      password: json['password'] ?? '', // Handle null values
      isAdmin: json['isAdmin'] ?? false, // Default to false if not provided
    );
  }
}
