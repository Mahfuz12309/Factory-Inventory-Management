import 'package:flutter/material.dart';
import 'package:garments_inventory/screens/buyer_supplier/ordersByPartyPage.dart';
import 'package:garments_inventory/services/database_service.dart';
import 'package:garments_inventory/model/party_model.dart';

class PartyPage extends StatefulWidget {
  final bool isAdmin; // Whether the current user is an admin

  const PartyPage({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _PartyPageState createState() => _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  List<Party> _partyList = [];

  @override
  void initState() {
    super.initState();
    _fetchPartyList();
  }

  // Fetch party list from database
  void _fetchPartyList() async {
    var parties = await DatabaseService().getAllParties();
    setState(() {
      _partyList = parties;
    });
  }

  // Add a new party
  void _addParty() async {
    Party newParty = Party(
      id: '', // Firestore will generate the ID automatically
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      contact: _contactController.text,
    );

    await DatabaseService().createParty(newParty);
    _fetchPartyList(); // Refresh list after adding
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _contactController.clear();
  }

  // Delete a party (admin only)
  void _deleteParty(String partyId) async {
    await DatabaseService().deleteParty(partyId);
    _fetchPartyList(); // Refresh list after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Parties'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Party Form
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Party Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact Info'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addParty,
              child: const Text('Add Party'),
            ),
            const SizedBox(height: 20),
            // Party List
            Expanded(
              child: _partyList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _partyList.length,
                      itemBuilder: (context, index) {
                        var party = _partyList[index];
                        return ListTile(
                          title: GestureDetector(
                            child: Text(
                              party.name,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              // Navigate to OrdersByPartyPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrdersByPartyPage(partyId: party.id,partyName:party.name),
                                ),
                              );
                            },
                          ),
                          subtitle: Text(
                              '${party.phone}, ${party.address}, ${party.contact}'),
                          trailing: widget.isAdmin
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteParty(party.id),
                                )
                              : null, // No delete option for regular users
                        );
                      },
                    )
                  : const Center(child: Text('No parties available')),
            ),
          ],
        ),
      ),
    );
  }
}
