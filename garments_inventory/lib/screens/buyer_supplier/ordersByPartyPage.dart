import 'package:flutter/material.dart';
import 'package:garments_inventory/model/order_model.dart';
import 'package:garments_inventory/services/order_services.dart';

class OrdersByPartyPage extends StatefulWidget {
  final String partyId;
  final String partyName;

  const OrdersByPartyPage({Key? key, required this.partyId, required this.partyName}) : super(key: key);

  @override
  _OrdersByPartyPageState createState() => _OrdersByPartyPageState();
}

class _OrdersByPartyPageState extends State<OrdersByPartyPage> {
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrdersByParty();
  }

  // Fetch orders by party ID and name
  void _fetchOrdersByParty() async {
    List<Order> orders = await OrderService().getOrdersByParty(widget.partyId);
    
    // Filter orders where partyName matches the provided partyName
    List<Order> filteredOrders = orders.where((order) => order.partyName == widget.partyName).toList();

    setState(() {
      _orders = filteredOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders for Party'),
      ),
      body: _orders.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                Order order = _orders[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Order Number: ${order.orderNumber}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Party Name: ${order.partyName}'),
                        Text('Yarn Composition: ${order.yarnComposition}'),
                        Text('Color: ${order.color}'),
                        Text('Delivery Quantity: ${order.deliveryQuantity}'),
                        Text('Balance: ${order.balance}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () {
                        // Navigate to order detail page (if you have one)
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
