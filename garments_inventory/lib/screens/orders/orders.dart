import 'package:flutter/material.dart';
import 'package:garments_inventory/model/order_model.dart';
import 'package:garments_inventory/screens/orders/all_order.dart';
import 'package:garments_inventory/screens/orders/details_order.dart'; // Make sure to import your DetailsOrder page
import 'package:garments_inventory/services/database_service.dart';
import 'package:garments_inventory/services/order_services.dart';
import 'package:intl/intl.dart';
import 'package:garments_inventory/model/party_model.dart';

class OrderPage extends StatefulWidget {
  final String partyId;

  const OrderPage({Key? key, required this.partyId}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _orderNumberController = TextEditingController();
  final TextEditingController _codeNumberController = TextEditingController();
  final TextEditingController _yarnCompositionController = TextEditingController();
  final TextEditingController _machineDiameterController = TextEditingController();
  final TextEditingController _fabricDiameterController = TextEditingController();
  final TextEditingController _fabricTypeController = TextEditingController();
  final TextEditingController _fabricGSMController = TextEditingController();
  final TextEditingController _sampleLengthController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _receiveChalanaNoController = TextEditingController();
  final TextEditingController _receiveQuantityController = TextEditingController();
  final TextEditingController _deliveryChalanaNoController = TextEditingController();
  final TextEditingController _deliveryQuantityController = TextEditingController();

  String _selectedPartyId = ''; // Store the selected party ID
  String _selectedPartyName = ''; // Store the selected party Name
  DateTime? _receiveDate;
  DateTime? _deliveryDate;

  List<Party> _parties = [];

  @override
  void initState() {
    super.initState();
    _fetchParties();
  }

  void _fetchParties() async {
    List<Party> parties = await DatabaseService().getAllParties();
    setState(() {
      _parties = parties;
    });
  }

  void _selectReceiveDateTime() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        setState(() {
          _receiveDate = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  void _selectDeliveryDateTime() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        setState(() {
          _deliveryDate = DateTime(picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  void _createOrder() async {
    if (_selectedPartyId.isEmpty || 
        _codeNumberController.text.isEmpty ||
        _yarnCompositionController.text.isEmpty ||
        _machineDiameterController.text.isEmpty ||
        _fabricDiameterController.text.isEmpty ||
        _fabricTypeController.text.isEmpty ||
        _fabricGSMController.text.isEmpty ||
        _sampleLengthController.text.isEmpty ||
        _colorController.text.isEmpty ||
        _receiveChalanaNoController.text.isEmpty ||
        _receiveQuantityController.text.isEmpty ||
        _deliveryChalanaNoController.text.isEmpty ||
        _deliveryQuantityController.text.isEmpty ||
        _receiveDate == null ||
        _deliveryDate == null) {
          
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields.")));
      return; 
    }

    try {
      String orderNumber = _orderNumberController.text;
      String partyId = _selectedPartyId;
      String partyName = _selectedPartyName; // Save the selected party name
      String codeNumber = _codeNumberController.text;
      String yarnComposition = _yarnCompositionController.text;
      String machineDiameter = _machineDiameterController.text;
      String fabricDiameter = _fabricDiameterController.text;
      String fabricType = _fabricTypeController.text;
      double fabricGSM = double.tryParse(_fabricGSMController.text) ?? 0.0;
      double sampleLength = double.tryParse(_sampleLengthController.text) ?? 0.0;
      String color = _colorController.text;
      String receiveChalanaNo = _receiveChalanaNoController.text;
      double receiveQuantity = double.tryParse(_receiveQuantityController.text) ?? 0.0;
      String deliveryChalanaNo = _deliveryChalanaNoController.text;
      double deliveryQuantity = double.tryParse(_deliveryQuantityController.text) ?? 0.0;
      double balance = receiveQuantity - deliveryQuantity;
      String remarks = _remarksController.text;

      Order newOrder = Order(
        id: '',
        partyId: partyId, 
        partyName: partyName, // Save the party name
        orderNumber: orderNumber,
        codeNumber: codeNumber,
        yarnComposition: yarnComposition,
        machineDiameter: machineDiameter,
        fabricDiameter: fabricDiameter,
        fabricType: fabricType,
        fabricGSM: fabricGSM,
        sampleLength: sampleLength,
        color: color,
        receiveDate: _receiveDate!,
        receiveChalanaNo: receiveChalanaNo,
        receiveQuantity: receiveQuantity,
        deliveryDate: _deliveryDate!,
        deliveryChalanaNo: deliveryChalanaNo,
        deliveryQuantity: deliveryQuantity,
        balance: balance,
        remarks: remarks, updateHistory: [],
      );

      await OrderService().createOrder(newOrder);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Created Successfully")));
      
      // Reset all fields after creating the order
      _resetFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error creating order: $e")));
    }
  }

  void _resetFields() {
    _orderNumberController.clear();
    _codeNumberController.clear();
    _yarnCompositionController.clear();
    _machineDiameterController.clear();
    _fabricDiameterController.clear();
    _fabricTypeController.clear();
    _fabricGSMController.clear();
    _sampleLengthController.clear();
    _colorController.clear();
    _receiveChalanaNoController.clear();
    _receiveQuantityController.clear();
    _deliveryChalanaNoController.clear();
    _deliveryQuantityController.clear();
    _remarksController.clear();
    _receiveDate = null;
    _deliveryDate = null;
    _selectedPartyId = '';
    _selectedPartyName = '';
  }

  void _navigateToDetailsOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AllOrdersPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Order"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: _navigateToDetailsOrder, 
            tooltip: 'Order History',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _orderNumberController,
                decoration: InputDecoration(labelText: "Order Number"),
                // Allow user input for the order number
              ),
              DropdownButtonFormField<String>(
                value: _selectedPartyId.isEmpty ? null : _selectedPartyId,
                items: _parties.map((Party party) {
                  return DropdownMenuItem<String>(
                    value: party.id,
                    child: Text(party.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPartyId = value ?? '';
                    _selectedPartyName = _parties.firstWhere((party) => party.id == _selectedPartyId).name; // Save party name
                  });
                },
                decoration: InputDecoration(labelText: 'Select Party'),
              ),
              TextField(
                controller: _codeNumberController,
                decoration: InputDecoration(labelText: "Code Number/KPS"),
              ),
              TextField(
                controller: _yarnCompositionController,
                decoration: InputDecoration(labelText: "Yarn Composition"),
              ),
              TextField(
                controller: _machineDiameterController,
                decoration: InputDecoration(labelText: "Machine Diameter"),
              ),
              TextField(
                controller: _fabricDiameterController,
                decoration: InputDecoration(labelText: "Fabric Diameter"),
              ),
              TextField(
                controller: _fabricTypeController,
                decoration: InputDecoration(labelText: "Fabric Type"),
              ),
              TextField(
                controller: _fabricGSMController,
                decoration: InputDecoration(labelText: "Fabric GSM"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _sampleLengthController,
                decoration: InputDecoration(labelText: "Sample Length"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(labelText: "Color"),
              ),
              TextField(
                controller: _receiveChalanaNoController,
                decoration: InputDecoration(labelText: "Receive Chalana No"),
              ),
              TextField(
                controller: _receiveQuantityController,
                decoration: InputDecoration(labelText: "Receive Quantity"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _deliveryChalanaNoController,
                decoration: InputDecoration(labelText: "Delivery Chalana No"),
              ),
              TextField(
                controller: _deliveryQuantityController,
                decoration: InputDecoration(labelText: "Delivery Quantity"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _remarksController,
                decoration: InputDecoration(labelText: "Remarks"),
              ),
              ElevatedButton(
                onPressed: _selectReceiveDateTime,
                child: Text(_receiveDate == null
                    ? 'Select Receive Date & Time'
                    : DateFormat('yyyy-MM-dd HH:mm').format(_receiveDate!)),
              ),
              ElevatedButton(
                onPressed: _selectDeliveryDateTime,
                child: Text(_deliveryDate == null
                    ? 'Select Delivery Date & Time'
                    : DateFormat('yyyy-MM-dd HH:mm').format(_deliveryDate!)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createOrder,
                child: Text("Create Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
