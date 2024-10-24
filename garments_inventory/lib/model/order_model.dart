class Order {
  String id; // Firestore document ID
  String partyId; // ID of the party (buyer/seller)
  String partyName; // Name of the party
  String orderNumber; // Buy/Order number
  String codeNumber; // Code number/KPS
  String yarnComposition; // Yarn composition
  String machineDiameter; // M/C Dia
  String fabricDiameter; // F/Dia
  String fabricType; // FAB/Type
  double fabricGSM; // F/GSM
  double sampleLength; // S/L
  String color; // Color
  DateTime receiveDate; // Receive date
  String receiveChalanaNo; // Chalana No for received goods
  double receiveQuantity; // Quantity received
  DateTime deliveryDate; // Delivery date
  String deliveryChalanaNo; // Chalana No for delivered goods
  double deliveryQuantity; // Quantity delivered
  double balance; // Remaining balance
  String remarks; // Remarks
  List<Map<String, dynamic>> updateHistory; // List of updates with date

  Order({
    required this.id,
    required this.partyId,
    required this.partyName, // Added party name
    required this.orderNumber,
    required this.codeNumber,
    required this.yarnComposition,
    required this.machineDiameter,
    required this.fabricDiameter,
    required this.fabricType,
    required this.fabricGSM,
    required this.sampleLength,
    required this.color,
    required this.receiveDate,
    required this.receiveChalanaNo,
    required this.receiveQuantity,
    required this.deliveryDate,
    required this.deliveryChalanaNo,
    required this.deliveryQuantity,
    required this.balance,
    required this.remarks,
    required this.updateHistory, // Added update history
  });

  // Convert an Order object to a map to save in Firestore
  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'partyName': partyName, // Added party name
      'orderNumber': orderNumber,
      'codeNumber': codeNumber,
      'yarnComposition': yarnComposition,
      'machineDiameter': machineDiameter,
      'fabricDiameter': fabricDiameter,
      'fabricType': fabricType,
      'fabricGSM': fabricGSM,
      'sampleLength': sampleLength,
      'color': color,
      'receiveDate': receiveDate.toIso8601String(),
      'receiveChalanaNo': receiveChalanaNo,
      'receiveQuantity': receiveQuantity,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryChalanaNo': deliveryChalanaNo,
      'deliveryQuantity': deliveryQuantity,
      'balance': balance,
      'remarks': remarks,
      'updateHistory': updateHistory, // Save the update history as a list
    };
  }

  // Create an Order object from Firestore map data
  factory Order.fromJson(String id, Map<String, dynamic> json) {
    return Order(
      id: id,
      partyId: json['partyId'] ?? '',
      partyName: json['partyName'] ?? '', // Added party name
      orderNumber: json['orderNumber'] ?? '',
      codeNumber: json['codeNumber'] ?? '',
      yarnComposition: json['yarnComposition'] ?? '',
      machineDiameter: json['machineDiameter'] ?? '',
      fabricDiameter: json['fabricDiameter'] ?? '',
      fabricType: json['fabricType'] ?? '',
      fabricGSM: json['fabricGSM'] ?? 0.0,
      sampleLength: json['sampleLength'] ?? 0.0,
      color: json['color'] ?? '',
      receiveDate: DateTime.parse(json['receiveDate'] ?? DateTime.now().toIso8601String()),
      receiveChalanaNo: json['receiveChalanaNo'] ?? '',
      receiveQuantity: json['receiveQuantity'] ?? 0.0,
      deliveryDate: DateTime.parse(json['deliveryDate'] ?? DateTime.now().toIso8601String()),
      deliveryChalanaNo: json['deliveryChalanaNo'] ?? '',
      deliveryQuantity: json['deliveryQuantity'] ?? 0.0,
      balance: json['balance'] ?? 0.0,
      remarks: json['remarks'] ?? '',
      updateHistory: List<Map<String, dynamic>>.from(json['updateHistory'] ?? []), // Fetch update history
    );
  }

  // Add the copyWith method
  Order copyWith({
    String? id,
    String? partyId,
    String? partyName,
    String? orderNumber,
    String? codeNumber,
    String? yarnComposition,
    String? machineDiameter,
    String? fabricDiameter,
    String? fabricType,
    double? fabricGSM,
    double? sampleLength,
    String? color,
    DateTime? receiveDate,
    String? receiveChalanaNo,
    double? receiveQuantity,
    DateTime? deliveryDate,
    String? deliveryChalanaNo,
    double? deliveryQuantity,
    double? balance,
    String? remarks,
    List<Map<String, dynamic>>? updateHistory,
  }) {
    return Order(
      id: id ?? this.id,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      orderNumber: orderNumber ?? this.orderNumber,
      codeNumber: codeNumber ?? this.codeNumber,
      yarnComposition: yarnComposition ?? this.yarnComposition,
      machineDiameter: machineDiameter ?? this.machineDiameter,
      fabricDiameter: fabricDiameter ?? this.fabricDiameter,
      fabricType: fabricType ?? this.fabricType,
      fabricGSM: fabricGSM ?? this.fabricGSM,
      sampleLength: sampleLength ?? this.sampleLength,
      color: color ?? this.color,
      receiveDate: receiveDate ?? this.receiveDate,
      receiveChalanaNo: receiveChalanaNo ?? this.receiveChalanaNo,
      receiveQuantity: receiveQuantity ?? this.receiveQuantity,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryChalanaNo: deliveryChalanaNo ?? this.deliveryChalanaNo,
      deliveryQuantity: deliveryQuantity ?? this.deliveryQuantity,
      balance: balance ?? this.balance,
      remarks: remarks ?? this.remarks,
      updateHistory: updateHistory ?? this.updateHistory,
    );
  }
}
