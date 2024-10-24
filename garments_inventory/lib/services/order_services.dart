import 'package:firedart/firedart.dart';
import 'package:garments_inventory/model/order_model.dart';

class OrderService {
  final Firestore _firestore = Firestore.instance;
  final String collection = 'orders'; // The Firestore collection to store orders

  // Create a new order in Firestore
  Future<void> createOrder(Order order) async {
    try {
      await _firestore.collection(collection).add(order.toJson());
      print("Order created successfully");
    } catch (e) {
      print("Error creating order: $e");
    }
  }

  // Get all orders for a specific party
  Future<List<Order>> getOrdersByParty(String partyId) async {
    try {
      var ordersSnapshot = await _firestore
          .collection(collection)
          .where('partyId', isEqualTo: partyId)
          .get();
      return ordersSnapshot.map((doc) => Order.fromJson(doc.id, doc.map)).toList();
    } catch (e) {
      print("Error getting orders: $e");
      return [];
    }
  }

  // Get the next order number for the party
  Future<String> getNextOrderNumber(String partyId) async {
    List<Order> orders = await getOrdersByParty(partyId);
    int nextOrderNumber = orders.length + 1; // Increment from current order count
    return nextOrderNumber.toString();
  }

  // Update an existing order
  Future<void> updateOrder(Order order) async {
    try {
      await _firestore.collection(collection).document(order.id).update({
        'deliveryQuantity': order.deliveryQuantity,
        'balance': order.balance,
        // Add any other fields you want to update
      });
      print('Order updated successfully: ${order.id}');
    } catch (e) {
      print('Failed to update order: $e');
    }
  }

  // Method to get all orders
  Future<List<Order>> getAllOrders() async {
    try {
      List<Document> documents = await _firestore.collection(collection).get(); // Get all documents in the collection
      List<Order> orders = documents.map((doc) {
        Map<String, dynamic> data = doc.map; // Firedart uses 'map' to get the document data
        return Order.fromJson(doc.id, data); // Convert to Order object
      }).toList();

      return orders;
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

// Get order by ID
Future<Order?> getOrderById(String orderId) async {
  try {
    Document orderDoc = await _firestore.collection(collection).document(orderId).get();
    // Check if the document data is not empty
    if (orderDoc.map.isNotEmpty) {
      return Order.fromJson(orderDoc.id, orderDoc.map); // Convert to Order object
    }
    return null; // Return null if order not found
  } catch (e) {
    print("Error fetching order by ID: $e");
    return null; // Handle error
  }
}


  // Method to get the next global order number
  Future<String> getNextGlobalOrderNumber() async {
    try {
      int highestOrderNumber = await fetchHighestOrderNumber();
      return (highestOrderNumber + 1).toString();
    } catch (e) {
      print("Error fetching highest order number: $e");
      throw Exception('Could not fetch global order number');
    }
  }

  // Helper method to fetch the highest order number from Firestore
  Future<int> fetchHighestOrderNumber() async {
    try {
      var orderSnapshot = await _firestore.collection(collection).orderBy('orderNumber', descending: true).limit(1).get();
      if (orderSnapshot.isNotEmpty) {
        var highestOrderDoc = orderSnapshot.first; // Get the first document (highest order number)
        return highestOrderDoc.map['orderNumber'] ?? 0; // Return the order number or 0 if not found
      }
      return 0; // No orders exist, return 0
    } catch (e) {
      print("Error fetching highest order number: $e");
      return 0; // In case of error, assume no orders exist
    }
  }
}
