import 'package:flutter/material.dart';
import 'package:garments_inventory/screens/authencate/admin_panel_page.dart';
import 'package:garments_inventory/screens/authencate/login.dart';
import 'package:garments_inventory/screens/balance_sheet/view_balance_sheet.dart';
import 'package:garments_inventory/screens/buyer_supplier/party_details.dart';
import 'package:garments_inventory/screens/invoice/generate_pdf.dart';
import 'package:garments_inventory/screens/orders/orders.dart';

class Dashboard extends StatelessWidget {
  final bool isAdmin;

  const Dashboard({Key? key, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knit Wear Dashboard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDashboardTile(
              context,
              icon: Icons.person,
              label: 'Buyers/Suppliers',
              route: PartyPage(isAdmin: isAdmin,),
            ),
            const SizedBox(width: 20),
            _buildDashboardTile(
              context,
              icon: Icons.shopping_bag,
              label: 'Orders',
              route: OrderPage(partyId: '',),
            ),
            const SizedBox(width: 20),
            _buildDashboardTile(
              context,
              icon: Icons.attach_money,
              label: 'Balance Sheet',
              route: ViewBalanceSheet(),
            ),
            const SizedBox(width: 20),
            _buildDashboardTile(
              context,
              icon: Icons.picture_as_pdf,
              label: 'Generate Invoice',
              route: GeneratePDFInvoice(),
            ),
            const SizedBox(width: 20),

            if (isAdmin)
              _buildDashboardTile(
                context,
                icon: Icons.admin_panel_settings,
                label: 'Admin Panel',
                route: const AdminPage(),
              ),
            const SizedBox(width: 20),

            _buildDashboardTile(
              context,
              icon: Icons.logout,
              label: 'Log Out',
              route: LoginPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context, {required IconData icon, required String label, required Widget route}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => route),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(icon, size: 50, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
