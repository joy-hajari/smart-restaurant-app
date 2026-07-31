import 'food_item.dart';

class OrderItem {
  final FoodItem food;
  final int quantity;

  OrderItem({
    required this.food,
    required this.quantity,
  });
}

class OrderModel {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  String status; // 'pending', 'preparing', 'outForDelivery', 'delivered'
  final DateTime timestamp;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
    required this.timestamp,
  });
}