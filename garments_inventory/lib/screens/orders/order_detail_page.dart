import 'package:flutter/material.dart';
import 'package:garments_inventory/model/order_model.dart';
import 'package:garments_inventory/services/order_services.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId; // Pass the orderId to the page

  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Order? _order; // To store the order details
  bool _isLoading = true; // Loading indicator
  ScrollController _horizontalScrollController = ScrollController();
  ScrollController _verticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails(); // Fetch order details when the page loads
  }

  // Fetch the order details based on the orderId
  void _fetchOrderDetails() async {
    try {
      Order? order = await OrderService()
          .getOrderById(widget.orderId); // Fetch specific order by orderId
      setState(() {
        _order = order;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching order details: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching
          : _order == null
              ? Center(child: Text('No order found')) // Show if no order found
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
                      scrollDirection: Axis
                          .horizontal, // Enable horizontal scrolling for table
                      controller: _horizontalScrollController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis
                            .vertical, // Enable vertical scrolling for table
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
                          rows: [
                            DataRow(cells: [
                              DataCell(Text(_order!.orderNumber)),
                              DataCell(Text(_order!.partyName)),
                              DataCell(Text(_order!.codeNumber)),
                              DataCell(Text(_order!.yarnComposition)),
                              DataCell(Text(_order!.machineDiameter)),
                              DataCell(Text(_order!.fabricDiameter)),
                              DataCell(Text(_order!.fabricType)),
                              DataCell(Text(_order!.fabricGSM.toString())),
                              DataCell(Text(_order!.sampleLength.toString())),
                              DataCell(Text(_order!.color)),
                              DataCell(Text(_order!.receiveChalanaNo)),
                              DataCell(
                                  Text(_order!.receiveQuantity.toString())),
                              DataCell(Text(_order!.deliveryChalanaNo)),
                              DataCell(
                                  Text(_order!.deliveryQuantity.toString())),
                              DataCell(Text(_order!.balance.toString())),
                              DataCell(Text(_order!.remarks)),
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
