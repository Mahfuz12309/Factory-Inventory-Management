class Party {
  String id; // Firestore document ID
  String name; // Name of the party (buyer/seller)
  String phone; // Phone number of the party
  String address; // Address of the party
  String contact; // Contact person information

  Party({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.contact,
  });

  // Convert a Party object to a map to save in Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'contact': contact,
    };
  }

  // Create a Party object from Firestore map data
  factory Party.fromJson(String id, Map<String, dynamic> json) {
    return Party(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      contact: json['contact'] ?? '',
    );
  }
}
