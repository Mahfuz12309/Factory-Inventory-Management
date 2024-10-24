import 'package:flutter/material.dart';
import 'package:garments_inventory/model/order_model.dart';
import 'package:garments_inventory/services/order_services.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({Key? key}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List<Order> _orders = [];
  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAllOrders(); // Fetch all orders when the page loads
  }

  // Fetch all orders from the database
  void _fetchAllOrders() async {
    List<Order> orders = await OrderService().getAllOrders(); // Fetch all orders using your OrderService
    setState(() {
      _orders = orders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
      ),
      body: _orders.isEmpty
          ? Center(child: CircularProgressIndicator()) // Show loading spinner if orders are not fetched yet
          : MouseRegion(
              onEnter: (_) {
                // Enable mouse hovering
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: GestureDetector(
                onPanUpdate: (details) {
                  // Scroll the table on mouse drag
                  _horizontalScrollController.position.moveTo(
                    _horizontalScrollController.offset - details.delta.dx,
                  );
                  _verticalScrollController.position.moveTo(
                    _verticalScrollController.offset - details.delta.dy,
                  );
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                  controller: _horizontalScrollController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // Enable vertical scrolling
                    controller: _verticalScrollController,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Order Number')),
                        DataColumn(label: Text('Party Name')),
                        DataColumn(label: Text('Code Number')),
                        DataColumn(label: Text('Yarn Composition')),
                        DataColumn(label: Text('Machine Diameter')),
                        DataColumn(label: Text('Fabric Diameter')),
                        DataColumn(label: Text('Fabric Type')),
                        DataColumn(label: Text('Fabric GSM')),
                        DataColumn(label: Text('Sample Length')),
                        DataColumn(label: Text('Color')),
                        DataColumn(label: Text('Receive Chalana No')),
                        DataColumn(label: Text('Receive Quantity')),
                        DataColumn(label: Text('Delivery Chalana No')),
                        DataColumn(label: Text('Delivery Quantity')),
                        DataColumn(label: Text('Balance')),
                        DataColumn(label: Text('Remarks')),
                      ],
                      rows: _orders.map((order) {
                        return DataRow(cells: [
                          DataCell(Text(order.orderNumber)),
                          DataCell(Text(order.partyName)),
                          DataCell(Text(order.codeNumber)),
                          DataCell(Text(order.yarnComposition)),
                          DataCell(Text(order.machineDiameter)),
                          DataCell(Text(order.fabricDiameter)),
                          DataCell(Text(order.fabricType)),
                          DataCell(Text(order.fabricGSM.toString())),
                          DataCell(Text(order.sampleLength.toString())),
                          DataCell(Text(order.color)),
                          DataCell(Text(order.receiveChalanaNo)),
                          DataCell(Text(order.receiveQuantity.toString())),
                          DataCell(Text(order.deliveryChalanaNo)),
                          DataCell(Text(order.deliveryQuantity.toString())),
                          DataCell(Text(order.balance.toString())),
                          DataCell(Text(order.remarks)),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
