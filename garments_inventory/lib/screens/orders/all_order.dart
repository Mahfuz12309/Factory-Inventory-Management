import 'package:flutter/material.dart';
import 'package:garments_inventory/model/order_model.dart'; // Updated path for order details page
import 'package:garments_inventory/screens/orders/order_detail_page.dart';
import 'package:garments_inventory/services/order_services.dart'; // Updated path for order service

class AllOrdersPage extends StatefulWidget {
  @override
  _AllOrdersPageState createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  final OrderService orderService = OrderService(); // OrderService to fetch and update orders
  List<Order> allOrders = []; // List to hold all orders
  List<Order> filteredOrders = []; // List to hold filtered orders based on search query
  String searchQuery = ''; // Search query string

  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the page loads
  }

  // Fetch all orders from Firestore
  void fetchOrders() async {
    try {
      List<Order> orders = await orderService.getAllOrders();
      setState(() {
        allOrders = orders;
        filteredOrders = orders; // Initially, show all orders
      });
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  // Filter orders based on search query (order number)
  void filterOrders(String query) {
    List<Order> filteredList = allOrders.where((order) {
      return order.orderNumber.contains(query); // Check if the order number contains the search query
    }).toList();

    setState(() {
      filteredOrders = filteredList;
      searchQuery = query;
    });
  }

  // Navigate to Order Details page using the orderId
  void navigateToOrderDetails(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderId: orderId), // Pass the orderId
      ),
    );
  }

  // Show the update order dialog
void showUpdateOrderDialog(Order order) {
  TextEditingController deliveryChalanaController = TextEditingController(text: order.deliveryChalanaNo);
  TextEditingController deliveryDateController = TextEditingController(text: order.deliveryDate.toIso8601String());
  TextEditingController deliveryQuantityController = TextEditingController(text: order.deliveryQuantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Delivery Details for Order ${order.orderNumber}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Read-only fields
              TextField(
                decoration: InputDecoration(labelText: 'Order Number'),
                readOnly: true,
                controller: TextEditingController(text: order.orderNumber),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Party Name'),
                readOnly: true,
                controller: TextEditingController(text: order.partyName),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Code Number'),
                readOnly: true,
                controller: TextEditingController(text: order.codeNumber),
              ),
              // Editable delivery fields
              TextField(
                decoration: InputDecoration(labelText: 'Delivery Chalana No'),
                controller: deliveryChalanaController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Delivery Date'),
                controller: deliveryDateController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Delivery Quantity'),
                controller: deliveryQuantityController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
              // Compare old and new delivery details
              bool isDeliveryChanged = order.deliveryChalanaNo != deliveryChalanaController.text ||
                  order.deliveryDate.toIso8601String() != deliveryDateController.text ||
                  order.deliveryQuantity != double.parse(deliveryQuantityController.text);

              if (isDeliveryChanged) {
                // Create a map for the update history
                Map<String, dynamic> updateEntry = {
                  'updatedAt': DateTime.now().toIso8601String(), // Timestamp of the update
                  'previousDeliveryChalanaNo': order.deliveryChalanaNo,
                  'previousDeliveryDate': order.deliveryDate.toIso8601String(),
                  'previousDeliveryQuantity': order.deliveryQuantity,
                };

                // Add the update entry to the history list
                List<Map<String, dynamic>> updatedHistory = List.from(order.updateHistory)
                  ..add(updateEntry);

                // Update the order with new delivery details and update history
                Order updatedOrder = order.copyWith(
                  deliveryChalanaNo: deliveryChalanaController.text,
                  deliveryDate: DateTime.parse(deliveryDateController.text),
                  deliveryQuantity: double.parse(deliveryQuantityController.text),
                  updateHistory: updatedHistory, // Add the updated history
                );

                await orderService.updateOrder(updatedOrder); // Save updated order to the database
                fetchOrders(); // Refresh the list
                Navigator.pop(context); // Close the dialog
              }
            },
            child: Text('Update'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterOrders, // Filter orders as user types
              decoration: InputDecoration(
                hintText: 'Search by Order Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                Order order = filteredOrders[index];
                return ListTile(
                  title: Text('Order Number: ${order.orderNumber}'),
                  subtitle: Text('Customer: ${order.partyName}, Quantity: ${order.deliveryQuantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => navigateToOrderDetails(order.id), // Navigate to the details page
                        child: Text('Order Details'),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => showUpdateOrderDialog(order), // Show update dialog
                        child: Text('Update Order'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
